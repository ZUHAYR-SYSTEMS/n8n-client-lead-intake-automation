# Security and Privacy

## Purpose

This repository is intended for public portfolio use and is designed to present automation engineering evidence without exposing credentials, private identifiers, or real customer data.

## Public-safe controls

The public layer is designed to exclude:

- passwords
- API keys
- bearer tokens
- access tokens
- refresh tokens
- client secrets
- private keys
- production credentials
- real client data
- production endpoints

Synthetic data is used for public examples and evidence.

## Credential handling

Any user importing this workflow into n8n should configure their own credentials and environment-specific settings.

Credentials and secrets should never be committed to source control.

## Public workflow export

The workflow included in this repository is a sanitized public-safe copy.

The original internal workflow and evidence remain preserved separately.

## Privacy

This project does not claim compliance with any specific privacy or security framework.

A real production implementation would require its own review for:

- data minimization
- access control
- retention policy
- logging policy
- secrets management
- environment isolation
- regulatory requirements
- downstream system security

## Disclosure

This is a simulated/internal automation lab using synthetic data.

It was built and tested locally.

It is not paid client work and is not a production deployment.
