# Issue: Set up GCP infrastructure

**Type:** infrastructure
**Priority:** low — needed for production, not local dev
**Repo:** dime-ops
**Epic:** epic-production
**Blocked by:** DECISION-004 (GCP native vs Neon+Upstash)

## GCP resources to provision

### Project + IAM
- [ ] GCP project `acts-of-defiance` (or confirm existing project)
- [ ] Service accounts: `dime-api`, `dime-worker`, `dime-deploy`
- [ ] IAM roles: least privilege — `dime-api` gets Cloud SQL client + Secret Manager accessor; `dime-worker` gets GCS write + Secret Manager accessor
- [ ] Workload Identity Federation for GitHub Actions deploy (no long-lived service account keys)

### Database (per DECISION-004)
**Option A — GCP native:**
- [ ] Cloud SQL (Postgres 16), `db-f1-micro` for low volume
- [ ] Private IP, VPC connector for Cloud Run

**Option B — Neon:**
- [ ] Neon project, connection string in Secret Manager

### Broker (per DECISION-004)
**Option A — GCP native:**
- [ ] Memorystore Redis (basic tier)

**Option B — Upstash:**
- [ ] Upstash Redis, connection string in Secret Manager

### Storage
- [ ] GCS bucket: `acts-of-defiance-images` (or similar)
- [ ] Bucket IAM: `dime-worker` write, public read for published images

### Secrets
- [ ] Secret Manager secrets: DATABASE_URL, BROKER_URL, GOOGLE_API_KEY, GEMINI_API_KEY, GCS_BUCKET
- [ ] Rotate secrets from `.env` into Secret Manager (follow up from rotate-exposed-api-key ticket)

### Networking
- [ ] VPC if using Cloud SQL (private IP)
- [ ] Serverless VPC connector for Cloud Run → VPC

## Cost target

~$25-30/month at low volume. See `docs/specs/dime-deployment.md` for breakdown.

## Acceptance criteria

- [ ] `dime-ops/setup/doctor.sh` GCP connectivity checks pass
- [ ] Cloud Run can connect to database and broker
- [ ] GCS bucket accessible from Cloud Run worker
- [ ] No service account key files in any repo or local filesystem
- [ ] All secrets in Secret Manager (zero secrets in env files in git)
