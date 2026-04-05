# Dime — Deployment

## Local Development

Native services — no Docker required for daily dev. Run `dime-api` and `dime-worker` directly with `uv`. `.envrc` points to local Postgres, Redis, and filesystem paths.

```bash
uv run dime start        # starts FastAPI + worker
uv run dime health       # health check
```

Docker Compose is provided as opt-in for new developer onboarding, CI, and reproducing a prod-like environment:

```yaml
# docker-compose.yml
services:
  api:       # dime FastAPI
  worker:    # dime ADK workers
  postgres:
  redis:
# compendium/ and art/ mount as bind volumes — git works normally outside containers
```

## Production (Google Cloud)

| Service | GCP Product | Notes |
|---|---|---|
| dime-api | Cloud Run (always-on) | REST + WebSocket |
| dime-worker | Cloud Run Jobs | Spins up per task batch, scales to zero |
| PostgreSQL | Cloud SQL (db-f1-micro) | ~$10/month |
| Redis | Cloud Memorystore (basic 1GB) | ~$16/month |
| art/ storage | Cloud Storage | ~$0.02/GB |
| Secrets | Secret Manager | API keys, DB creds, OAuth |
| Containers | Artifact Registry | |

**Estimated early-stage cost: ~$25–30/month.** Acceptable for a single GCP stack.

Cloud Run Jobs for workers is the key cost decision: agent tasks are bursty and long-running. Jobs spin up on demand, run to completion, scale to zero. Near-zero cost between active sessions.

See `docs/decisions/open-decisions.md` DECISION-004 for lower-cost alternatives (Neon + Upstash) if GCP costs become a concern.

## CI/CD

- Merge to `main` → build containers → push to Artifact Registry → deploy to Cloud Run
- Astro site deploys independently: publish signal → Cloud Build trigger → `bun run build` → deploy to Firebase Hosting or Cloud Storage + CDN
- Separate pipelines — a broken article does not affect the site build

## Environment Variables

All config via `.envrc` locally, Secret Manager in production. No secrets in code or committed files. The exposed API key in `dime/.env` must be rotated before any development begins.
