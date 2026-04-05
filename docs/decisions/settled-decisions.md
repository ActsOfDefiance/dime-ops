# Settled Decisions

Architectural and tooling decisions that have been made. Kept for context and rationale.

---

## DECISION-001: Content versioning strategy

**Decision:** Option A — filesystem canonical, git as versioning layer.

**Why:** Markdown files in `compendium/` are the source of truth and may be edited outside dime (vim, direct git, etc.). The DB stores a lightweight pointer (`git_commit_hash`) in `article_checkpoint` at each human checkpoint. A full `content_snapshot` is written to the DB only at publish time as a forensic copy. Content blobs never live in the DB during active work. The `article_checkpoint` table was already designed for this — no schema changes needed.

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
- `feature-aod` — Astro + Svelte 5

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

## DECISION-002: UI framework & design system — shadcn-svelte + Tailwind

**Decision:** shadcn-svelte with Tailwind CSS for dime-ui.

**Why:** Built-in accessibility (ARIA, keyboard nav), consistent component patterns, and strong Svelte ecosystem support. Tailwind provides utility-first styling without fighting a component library's opinions.

**Scope:** dime-ui only. The acts-of-defiance publication site has its own design — no shared design system between the two.

**Next steps:** Run Stitch MCP to generate style guide and design tokens before scaffolding components.

**Reference:** `docs/wireframes/dime-ui-chat-panes.html`

---

## DECISION-003: Static site generator — Astro + Svelte 5

**Decision:** Astro with Svelte 5 for interactive components.

**Why:** Astro supports a progressive path from static to SSR. Start with a purely static site (pre-rendered HTML, deploy anywhere), then incrementally add interactive Svelte 5 islands for client-side interactivity, and eventually flip to SSR when server-side features are needed (ratings, user accounts, community engagement). Hugo can't offer this progression — if dynamic features are ever needed, it would require a full rewrite.

**What this is NOT:** A shared design system with dime-ui. The publication site and the chat dashboard are separate products with separate design concerns.

**Impact:**
- `PublishingAdapter` needs an `AstroAdapter` implementation (new file, same interface)
- `feature-aod` skill needs updating for Astro toolchain (Bun, Astro CLI)
- acts-of-defiance repo needs migration from Hugo to Astro
- DECISION-002 (dime-ui design system) is now fully independent of this decision

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
  acts-of-defiance  <- Astro + Svelte 5 site
  compendium        <- GPLv3 markdown articles (no images)
```

**`dime-ops` is the Claude working root** for org-level and cross-repo work. It holds: `CLAUDE.md` (org-level), `docs/memory/`, `docs/specs/`, `docs/decisions/`, `docs/wireframes/`, and `setup/` scripts.

Each sibling repo has a lean repo-specific `CLAUDE.md` and symlinks for `docs/memory/`, `docs/specs/`, `docs/decisions/` pointing to `../dime-ops/docs/`. The `setup link` command in `dime-ops` creates all symlinks. The `doctor` command checks and repairs them.

**Art/images:** not in git. Generated images are artifacts stored in GCS (FileSystemAdapter). `.xcf` files ignored/untracked.

**License separation:** compendium (GPLv3) and art (CC BY-SA) intentionally separate repos.
