# Issue: Set up CI/CD

**Type:** infrastructure
**Priority:** low — needed for production
**Repo:** dime-ops (pipelines), dime, dime-ui, acts-of-defiance
**Epic:** epic-production
**Blocked by:** set-up-gcp-infra

## Pipelines to create

### dime repo — test + deploy
```yaml
# .github/workflows/ci.yml
on: [push, pull_request]
jobs:
  test:
    - uv run pytest
    - uv run pyright
    - uv run ruff check

# .github/workflows/deploy.yml
on:
  push:
    branches: [main]
jobs:
  deploy-api:
    - Build Docker image
    - Push to Artifact Registry
    - Deploy to Cloud Run (API service)
  deploy-workers:
    - Build worker Docker image
    - Push to Artifact Registry
    - Update Cloud Run Jobs
```

### dime-ui repo — test + deploy
```yaml
on: [push, pull_request]
jobs:
  test:
    - bun run check
    - bun run test
  deploy:
    on: push to main
    - bun run build
    - Deploy to Cloud Run (or Netlify/Vercel — decide at time of work)
```

### acts-of-defiance repo — build + deploy site
```yaml
on: [push]  # dime publishes by pushing to this repo
jobs:
  build:
    - bun run build
    - Deploy to Cloud Storage + CDN (or Netlify/Vercel)
```

## Notes

- Use Workload Identity Federation for GCP auth (no service account key files)
- Branch protection should require CI to pass before merge to main/develop
- Separate CI (test on all pushes) from CD (deploy only on main)

## Acceptance criteria

- [ ] `dime` CI: test job runs on every PR, all checks must pass
- [ ] `dime` CD: deploy job runs on merge to main, deploys API + workers to Cloud Run
- [ ] `acts-of-defiance` build: triggers on push to main, publishes site
- [ ] No service account keys in GitHub Secrets — use Workload Identity Federation
- [ ] Failed CI blocks merge (branch protection configured)
