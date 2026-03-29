# Issue: Define integration test strategy for adapters

**Type:** decision + tooling
**Priority:** medium — resolve before implementing adapters
**Repo:** dime
**Epic:** epic-dime-core

## Problem

The adapter layer (BrokerAdapter, FileSystemAdapter, GCS) requires integration tests against real external services. We need a clear policy on:

1. **Which tests require real services** (Postgres, Redis, GCS) vs. which use mocks
2. **How GCS integration tests are gated** — need a real bucket; can't run in every CI environment
3. **Local dev setup** — what services must be running locally for `uv run pytest` to pass
4. **CI environment** — which integration tests run in CI, and what infra does CI need

## Current assumption (from implement-adapters.md)

- Do NOT mock the broker or filesystem for integration tests (learned from past incidents)
- GCS tests gated behind `GCS_TEST_BUCKET` env var; skipped if not set
- Postgres and Redis assumed always available locally (native install or Docker Compose opt-in)

## Questions to resolve

- [ ] Is a real GCS test bucket acceptable for local dev, or do we use a local GCS emulator (fake-gcs-server)?
- [ ] Does CI provision real GCP services, or use emulators / Upstash free tier?
- [ ] Should `uv run pytest` pass with zero external services? Or is local Postgres + Redis required?
- [ ] Is there a separate `pytest -m integration` marker to run the full suite vs. unit-only?

## Recommendation

- Mark tests with `@pytest.mark.integration` for anything requiring real services
- `uv run pytest` (no args) runs unit tests only — zero services required
- `uv run pytest -m integration` requires Postgres + Redis + optionally GCS
- CI runs `pytest -m integration` with real Postgres + Redis (Docker services); GCS tests skipped unless `GCS_TEST_BUCKET` is set
- Local dev: doctor.sh checks for Postgres and Redis before running integration suite

## Action

Agree on the above (or adjust) and document the decision in `docs/decisions/open-decisions.md` as DECISION-009 before work on `implement-adapters.md` begins.
