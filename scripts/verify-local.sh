#!/usr/bin/env bash
# Imports the committed workflow export into a throwaway local n8n container,
# activates it, and checks each synthetic scenario against its expected response.
# Requires: docker, curl. Uses synthetic data only; no credentials.
set -euo pipefail

N8N_IMAGE="${N8N_IMAGE:-n8nio/n8n:2.36.9}"
PORT="${N8N_VERIFY_PORT:-5678}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW="$ROOT/workflow/client-lead-intake.public.json"
EXAMPLES="$ROOT/examples/synthetic-data"
WORKFLOW_ID="8JUIeRixxKJn7Zb2"
WEBHOOK_URL="http://127.0.0.1:${PORT}/webhook/client-lead-intake-v1"
RUN_ID="lead-intake-verify-$$"
LOG="$(mktemp)"
N8N_ENV=(
  -e N8N_DIAGNOSTICS_ENABLED=false
  -e N8N_VERSION_NOTIFICATIONS_ENABLED=false
  -e N8N_PERSONALIZATION_ENABLED=false
  -e N8N_ENCRYPTION_KEY=local-verification-only
)

cleanup() {
  docker rm -f "$RUN_ID" >/dev/null 2>&1 || true
  docker volume rm -f "$RUN_ID" >/dev/null 2>&1 || true
  rm -f "$LOG"
}
trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  [ -s "$LOG" ] && tail -n 20 "$LOG" >&2
  exit 1
}

n8n_cli() {
  docker run --rm -v "$RUN_ID:/home/node/.n8n" -v "$WORKFLOW:/workflow.json:ro" \
    "${N8N_ENV[@]}" "$N8N_IMAGE" "$@" >"$LOG" 2>&1
}

docker volume create "$RUN_ID" >/dev/null
echo "n8n version: $(docker run --rm "$N8N_IMAGE" --version | tail -n 1)"

n8n_cli import:workflow --input=/workflow.json || fail "import:workflow"
echo "import:workflow: OK"
n8n_cli publish:workflow --id="$WORKFLOW_ID" || fail "publish:workflow"
echo "publish:workflow: OK"

docker run -d --name "$RUN_ID" -p "127.0.0.1:${PORT}:5678" -v "$RUN_ID:/home/node/.n8n" \
  "${N8N_ENV[@]}" "$N8N_IMAGE" start >/dev/null

for _ in $(seq 1 60); do
  docker logs "$RUN_ID" 2>&1 | grep -q "Activated workflow" && break
  sleep 2
done
docker logs "$RUN_ID" >"$LOG" 2>&1
grep -q "Activated workflow" "$LOG" || fail "workflow did not activate"
echo "activation: OK"

failures=0
check() {
  local scenario="$1" expected_status="$2"
  local expected_body out status body
  expected_body="$(cat "$EXAMPLES/$scenario.expected.json")"
  out="$(curl -sS -w $'\n%{http_code}' -X POST "$WEBHOOK_URL" \
    -H 'Content-Type: application/json' --data-binary "@$EXAMPLES/$scenario.request.json")"
  status="${out##*$'\n'}"
  body="${out%$'\n'*}"
  if [ "$status" = "$expected_status" ] && [ "$body" = "$expected_body" ]; then
    echo "PASS $scenario: HTTP $status $body"
  else
    echo "FAIL $scenario: expected HTTP $expected_status $expected_body, got HTTP $status $body"
    failures=$((failures + 1))
  fi
}

echo "POST $WEBHOOK_URL"
check sales 200
check support 200
check invalid 400

[ "$failures" -eq 0 ] || fail "$failures scenario(s) failed"
echo "All 3 scenarios passed."
