# Architecture

## Purpose

The Client Lead Intake Automation demonstrates a structured intake and routing pattern implemented in n8n.

## Logical flow

```
Lead Source
    |
    v
Webhook (POST /webhook/client-lead-intake-v1)
    |
    v
Validate & Normalize (Code)
    |
    v
Valid Input? --- no ---> HTTP 400 { ok: false, errors }
    |
   yes
    |
    v
Route: Sales?
   /      \
 yes       no
  |         |
  v         v
Sales     Support
Result    Result
  \         /
   v       v
HTTP 200 { status, team, message }
```

## Engineering goals

The workflow was designed to demonstrate:

1. deterministic intake handling
2. structured field processing
3. clear separation between intake, logic, and output
4. explicit routing behavior
5. inspectable workflow logic
6. reproducible local testing
7. public-safe evidence packaging

## Data model

The lab uses synthetic lead data only.

Request fields read by the workflow:

- name (required)
- email (required, basic format check)
- department (required: sales or support)
- inquiry (optional)
- phone (optional)

Successful responses contain status, team, and message. Validation failures return ok: false and an errors list.

No real customer records are required for the portfolio version.

## Deployment boundary

The workflow is not presented as a production deployment.

Before real-world deployment, environment-specific concerns would need to be addressed, including:

- credentials
- authentication
- production webhook URLs
- rate limiting
- retry strategy
- monitoring
- secrets management
- data retention
- privacy requirements
- downstream system integration

## Disclosure

This architecture represents a simulated/internal automation lab using synthetic data.

It was built and tested locally and should not be represented as paid client work or a production deployment.
