# Epic: Production

**Type:** infrastructure / operations
**Priority:** low — needed before public launch, not a dev blocker
**Blocked by:** epic-dime-core (stable API), epic-acts-of-defiance (site working locally)

## Goal

Dime runs on GCP. The API is on Cloud Run (always-on). Workers run as Cloud Run Jobs (scale to zero). Postgres on Cloud SQL or Neon. Redis on Memorystore or Upstash. CI/CD deploys on merge to main. Observability in place.

## Decisions to resolve first

- [ ] DECISION-004: GCP native (Cloud SQL + Memorystore) vs managed external (Neon + Upstash) — cost and ops trade-off; resolve before provisioning infra
- [ ] DECISION-007: [decide-observability-tooling.md](decide-observability-tooling.md) — Logfire vs GCP Cloud Trace vs Sentry; resolve before first prod deploy

## Sub-issues

### GCP infrastructure
- [ ] [set-up-gcp-infra.md](set-up-gcp-infra.md) — GCP project, service accounts, IAM, Cloud SQL or Neon (per DECISION-004), Memorystore or Upstash, GCS bucket for images, Secret Manager for secrets

### API deployment
- [ ] Cloud Run service for FastAPI (always-on, min-instances=1)
- [ ] Environment config: DATABASE_URL, BROKER_URL, GCS credentials, API keys via Secret Manager

### Worker deployment
- [ ] Cloud Run Jobs for each worker type (research, writer, art_director, image, publisher)
- [ ] Scale-to-zero config; job dispatch via broker

### CI/CD
- [ ] [set-up-ci-cd.md](set-up-ci-cd.md) — GitHub Actions: test → build → deploy on merge to main (dime repo); Hugo/Astro build on acts-of-defiance repo

### Observability
- [ ] Configure chosen observability stack (per DECISION-007)
- [ ] Instrument API, pipeline state transitions, agent task lifecycle

### Security
- [ ] Gitflow branch protection on all repos (main + develop protected)
- [ ] Pre-commit hooks: reject commits with secret patterns (API keys, passwords)
- [ ] GCP VPC / private networking for Cloud SQL if using Cloud SQL

## Order

```
DECISION-004 + DECISION-007
    ↓
set-up-gcp-infra
    ↓ (parallel)
Cloud Run API deployment
Cloud Run Jobs worker deployment
    ↓
set-up-ci-cd
configure observability
    ↓
security hardening (branch protection + pre-commit hooks)
```

## Definition of Done

- [ ] `dime-ops/setup/doctor.sh` passes GCP connectivity checks
- [ ] API reachable at production URL; health check returns 200
- [ ] Worker jobs dispatch and complete successfully in GCP
- [ ] Merge to main triggers deploy; deploy completes without manual steps
- [ ] Observability: pipeline errors visible in chosen tool within 5 minutes
- [ ] No secrets in env vars; all loaded from Secret Manager
- [ ] Monthly GCP cost within estimate (~$25-30/month at low volume)
- [ ] Pre-commit hook blocks commits with secret patterns
