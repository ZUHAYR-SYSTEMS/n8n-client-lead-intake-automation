# Testing

## Status

PASS WITH DISCLOSURE / PORTFOLIO-READY

## Test purpose

Testing was performed to confirm that the workflow could process synthetic lead data and produce the expected routing and downstream output behavior.

## Test scope

The local lab test scope covers:

- structured lead intake
- field handling
- normalization behavior
- routing decisions
- expected downstream output paths
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
- test evidence preview from the original lab run; its inputs and HTTP results match the reproduced scenarios

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
