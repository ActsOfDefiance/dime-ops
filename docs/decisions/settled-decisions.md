# Settled Decisions

Architectural and tooling decisions that have been made. Kept for context and rationale.

---

## Documentation strategy

**Developer docs:** Markdown in `docs/` within each repo. Version-controlled alongside code, reviewable in PRs. No GitHub Wiki — it's per-repo and fragments in a multi-repo setup.

**User docs:** Deferred until dime has external users. When needed, user-facing docs can be generated directly from the architectural specs and design decisions in `docs/` — everything is already markdown, so conversion to a docs site (e.g. Astro Starlight) is a transformation step, not a separate authoring effort. No need to maintain a parallel documentation structure.

**Project management:** GitHub Issues for now. Revisit Linear when the first collaborator joins.

---

## DECISION-008: Claude Code skills per layer

**Decision:** Three separate skills, one per layer. Adapted from existing Python and Next.js feature development skills.

**Skills created:**
- `feature-dime` — Python/FastAPI/ADK/uv/ruff/pyright/pytest
- `feature-dime-ui` — SvelteKit/Bun/Vitest/Storybook/Playwright
- `feature-aod` — Hugo (with Astro migration path)

**Location:** `dime-ops/.claude/commands/`

**Why separate:** cleaner, easier to update independently, less cognitive load. Each skill is self-contained with its own quality gates, review cycle, and project context loading.

---

## DECISION-009: Integration test strategy

**Approach:**
- `@pytest.mark.integration` marker for any test requiring Postgres, Redis, or GCS
- `uv run pytest` (no args) = unit tests only, zero services required
- `uv run pytest -m integration` = requires local Postgres + Redis; GCS tests skipped unless `GCS_TEST_BUCKET` env var is set
- CI: runs integration suite with Docker-provisioned Postgres + Redis; GCS gated behind secret
- `doctor.sh` warns if Postgres or Redis are unreachable before running integration suite

**Open sub-question:** real GCS bucket vs. local GCS emulator (fake-gcs-server) for local integration tests.

**See:** `docs/issues/define-integration-test-strategy.md`

---

## Licensing

GPLv3 for all repos except art/image assets. Art assets (generated images, graphics) need separate licensing (likely CC BY-SA, stored in GCS not git). The `compendium` repo uses GPLv3 for article content.

---

## GitHub org repo naming

The `website` repo was renamed to `acts-of-defiance` to match the publication name. All repos use lowercase-hyphenated names.

---

## Repository structure

```
github.com/ActsOfDefiance/
  dime-ops          <- command center: Claude home, canonical context, setup + doctor commands
  dime              <- Python agent + FastAPI
  dime-ui           <- Svelte/SvelteKit frontend
  acts-of-defiance  <- Hugo/Astro site
  compendium        <- GPLv3 markdown articles (no images)
```

**`dime-ops` is the Claude working root** for org-level and cross-repo work. It holds: `CLAUDE.md` (org-level), `docs/memory/`, `docs/specs/`, `docs/decisions/`, `docs/wireframes/`, and `setup/` scripts.

Each sibling repo has a lean repo-specific `CLAUDE.md` and symlinks for `docs/memory/`, `docs/specs/`, `docs/decisions/` pointing to `../dime-ops/docs/`. The `setup link` command in `dime-ops` creates all symlinks. The `doctor` command checks and repairs them.

**Art/images:** not in git. Generated images are artifacts stored in GCS (FileSystemAdapter). `.xcf` files ignored/untracked.

**License separation:** compendium (GPLv3) and art (CC BY-SA) intentionally separate repos.
