# Issue: Rotate exposed secrets — URGENT

**Type:** security
**Priority:** CRITICAL — do immediately, before any other work
**Repo:** dime

## Problem

Multiple live secrets are present in `dime/.env` and `dime/.envrc`. If either file was ever committed, or if the repo is pushed to GitHub, these are compromised.

| Secret | Location | Value |
|---|---|---|
| `GOOGLE_API_KEY` / `GOOGLE_ADK_API_KEY` | `.env` line 2, `.envrc` line 37 | `AIzaSyAr4wXark8DBCDmbQA4DyABwD-oVXxB4_Q` |
| `LOGFIRE_TOKEN` | `.envrc` line 53 | `pylf_v1_us_jdQt3W...` |

## Actions

### 1. Rotate Google API key via gcloud
- [x] Switched gcloud project to `actsofdefiance`
- [x] Created new key `dime-dev` → `AIzaSyBpX2W7rKZlyQpAi_cVbQTzLj4N2gLpM84`
- [x] Deleted old exposed key from GCP

### 2. Rotate Logfire token
- [x] **MANUAL** — log in to logfire.pydantic.dev → Settings → API Tokens → revoke `pylf_v1_us_jdQt3W...` → create new token → update `.envrc` line 53

### 3. Update local secrets
- [x] Updated `GOOGLE_ADK_API_KEY` in `.envrc` with new key
- [x] Deleted `dime/.env`

### 4. Check and purge git history
- [x] `.env` — never committed (clean)
- [x] `.envrc` — was committed; old key found in commit `0cca87b`
- [x] Purged old key from all history with `git-filter-repo --replace-text --force`
- [x] Verified: 0 occurrences of old key remain in history
- [x] Verified: Logfire token also not in history

### 5. Verify .gitignore
- [x] Both `.env` and `.envrc` present in `.gitignore`

### 6. Add pre-commit hook
- [ ] Deferred — tracked in `epic-production.md` security section

### 7. Document secrets convention
- [x] Updated `dime/CLAUDE.md` with secrets convention

## Remaining
- [x] Rotate Logfire token manually (step 2)
- [ ] Pre-commit hook (epic-production)

## Sync to GitHub: yes — but complete Logfire rotation BEFORE the first push
