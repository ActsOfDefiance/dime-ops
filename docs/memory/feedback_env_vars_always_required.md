---
name: All env vars are always required — no partial env assumptions
description: Don't assume some env vars might be missing; all settings are always present via .envrc locally and proper env in CI/prod
type: feedback
---

When a reviewer suggests "ensure only X is required", reject it if the project already requires all env vars everywhere. In dime, DATABASE_URL and all other settings fields are always set — locally via `.envrc` with direnv, and in CI/production via proper environment configuration.

**Why:** The user corrected an assumption that DATABASE_URL might be the only env var needed for migrations. All env vars are always present; partial-env assumptions create inconsistency without real benefit.

**How to apply:** Don't add fallbacks or optional handling for env vars that are already declared required in `DimeSettings`. Trust that the full environment is always available when the application (or its tooling like Alembic) runs.
