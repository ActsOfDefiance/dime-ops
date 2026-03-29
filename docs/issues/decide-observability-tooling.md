# Issue: Decide and implement observability tooling

**Type:** decision + feature
**Priority:** medium — needed before production, not a dev blocker
**Repo:** dime

## Decision needed

See `docs/decisions/open-decisions.md` DECISION-007.

Logfire is already configured in the codebase. The new architecture (API + workers communicating via broker) benefits from distributed tracing more than the old single-process setup did.

## Options to evaluate

**Keep Logfire**
- Already integrated with FastAPI and SQLAlchemy
- Good structured logging
- Works with ADK
- Extra service and cost

**GCP Cloud Trace + Cloud Logging**
- Already in the GCP stack, no extra service
- Native distributed tracing across Cloud Run services
- OpenTelemetry compatible
- Free within GCP quotas

**Sentry**
- Error tracking + performance monitoring
- Generous free tier
- Excellent Python/FastAPI SDK
- Not in current stack

## What this decision affects

- Agent task lifecycle tracing (how long does each pipeline stage take?)
- Worker error visibility (what failed and why?)
- API request tracing
- Production debugging capability

## Action

Spike: set up each option in a branch, evaluate ease of use for the specific use case (multi-service, broker-mediated agent tasks). Pick one before the first production deploy.

## Sync to GitHub: yes
