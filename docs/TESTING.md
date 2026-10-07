# Testing

## Status

Simulated portfolio lab (synthetic data). Locally reproducible: the committed workflow passes 3 synthetic scenarios (sales 200, support 200, invalid 400) via `scripts/verify-local.sh` on n8n 2.36.9, CLI import path. Not deployed; not production-ready; editor (UI) import untested.

## Test purpose

Testing was performed to confirm that the workflow validates synthetic lead data, makes the sales/support routing decision, and returns the expected JSON HTTP response (200 for accepted leads, 400 with validation errors).

## Test scope

The local lab test scope covers:

- structured lead intake
- field handling
- normalization behavior
- routing decisions
- JSON HTTP response status codes and bodies
- evidence capture
- public-safe review

## Evidence

Public-safe evidence is stored under:

evidence/public/

Visual evidence is stored under:

screenshots/

Available evidence includes:

- test results reproduced by `scripts/verify-local.sh` (evidence/public/TEST_RESULTS.source.md)
- public-safe review
- historical test-log screenshot from the original lab run (screenshots/test-evidence-preview.png): a manually maintained evidence workbook that summarises that run's results. It is not workflow-generated output (the workflow writes no files); its inputs and HTTP status codes match the reproduced scenarios

## Reproducing the tests

Requirements: Docker and curl. No credentials or external services are used.

```
./scripts/verify-local.sh
```

The script:

1. imports the committed `workflow/client-lead-intake.public.json` unmodified into a throwaway `n8nio/n8n:2.36.9` container (override with `N8N_IMAGE`)
2. publishes (activates) the workflow
3. posts each `examples/synthetic-data/<case>.request.json` to `POST http://127.0.0.1:5678/webhook/client-lead-intake-v1` (override the port with `N8N_VERIFY_PORT`)
4. compares the HTTP status and exact JSON body with `examples/synthetic-data/<case>.expected.json`
5. removes the container and its volume

| Case | Input (name / email / department) | Expected HTTP | Expected body |
|---|---|---|---|
| sales | Alya Synthetic / alya@example.test / sales | 200 | `{"status":"qualified","team":"sales","message":"Synthetic lead accepted and routed to Sales."}` |
| support | Bima Synthetic / bima@example.test / support | 200 | `{"status":"received","team":"support","message":"Synthetic lead accepted and routed to Support."}` |
| invalid | (blank) / not-an-email / finance | 400 | `{"ok":false,"errors":["name is required","valid email is required","department must be sales or support"]}` |

The script exits non-zero if import, activation, or any scenario fails.

The workflow returns JSON responses only; it does not write spreadsheets or other files.

## Testing boundary

The test evidence demonstrates local workflow behavior using synthetic data.

It does not demonstrate:

- production uptime
- production traffic
- production load testing
- production monitoring
- production incident handling
- production security certification
- production SLA performance
- real customer data handling
- real revenue impact

## Evidence integrity

The original internal evidence set remains preserved separately from this repository.

This repository contains only a sanitized public presentation layer.

The original workflow and original evidence should not be modified for portfolio publication unless a material defect is discovered.

## Disclosure

This project is a simulated/internal automation lab using synthetic data.

It was built and tested locally.

It is not paid client work and is not a production deployment.
