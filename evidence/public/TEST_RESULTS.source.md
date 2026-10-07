# Functional Test Results — Reproducible Local Verification

Reproduce with `./scripts/verify-local.sh` (requires Docker and curl). The script imports the committed `workflow/client-lead-intake.public.json` unmodified into a throwaway local `n8nio/n8n:2.36.9` container, publishes it, and posts each payload from `examples/synthetic-data/` to `POST http://127.0.0.1:5678/webhook/client-lead-intake-v1`.

| Case | Synthetic input (name / email / department) | Expected and observed result | Status |
|---|---|---|---|
| Sales | Alya Synthetic / alya@example.test / sales | HTTP 200 `{"status":"qualified","team":"sales","message":"Synthetic lead accepted and routed to Sales."}` | PASS |
| Support | Bima Synthetic / bima@example.test / support | HTTP 200 `{"status":"received","team":"support","message":"Synthetic lead accepted and routed to Support."}` | PASS |
| Invalid | (blank) / not-an-email / finance | HTTP 400 `{"ok":false,"errors":["name is required","valid email is required","department must be sales or support"]}` | PASS |

Observed on a local run against n8n 2.36.9 on 2026-10-07. All test data is synthetic.

The workflow returns JSON responses only. It does not write spreadsheets or other files.

## Correction note

An earlier version of this file described XLSX output (`workflow_output/sales_lead.xlsx`, `workflow_output/support_lead.xlsx`), different synthetic names, and a different invalid department. Those claims could not be reproduced from the committed workflow export, which has no file-writing step, and were removed together with the spreadsheet output screenshots.
