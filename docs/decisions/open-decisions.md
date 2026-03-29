# Open Decisions

Deferred architectural and tooling decisions. Each entry has enough context to make the call when the time comes.

---

## Settled: Documentation strategy

**Developer docs:** Markdown in `docs/` within each repo. Version-controlled alongside code, reviewable in PRs. No GitHub Wiki — it's per-repo and fragments in a multi-repo setup.

**User docs:** Deferred until dime has external users. When needed, user-facing docs can be generated directly from the architectural specs and design decisions in `docs/` — everything is already markdown, so conversion to a docs site (e.g. Astro Starlight) is a transformation step, not a separate authoring effort. No need to maintain a parallel documentation structure.

**Project management:** GitHub Issues for now. Revisit Linear when the first collaborator joins.

---

## DECISION-001: Content versioning strategy

**Decision needed before:** implementing `FileSystemAdapter` + `VersioningAdapter`

**Options:**
- **A (recommended):** Filesystem canonical, git as versioning layer, DB stores `article_checkpoint` as lightweight pointer (git commit hash). Content snapshot only at publish time.
- **B:** DB canonical, filesystem is export. External edits require explicit import.
- **C:** Git-native — DB stores only git commit hash references, no content at all.

**Full trade-off analysis:** brainstorming session 2026-03-28. Option A aligns with the stated principle that markdown files are canonical and may be edited outside dime.

---

## DECISION-002: UI framework & design system

**Decision needed before:** UI implementation sprint

**Direction:** shadcn-svelte is the leading candidate (accessibility, ARIA, keyboard nav, consistent patterns). Stitch MCP is available in this environment to generate the style guide and design tokens.

**Action:** Run Stitch before committing to any component library. Confirm Tailwind dependency is acceptable. Verify no conflicts with the existing Svelte project being abstracted for reuse.

**Reference:** `docs/wireframes/dime-ui-chat-panes.html`

---

## DECISION-003: Static site generator — Hugo vs. Astro

**Decision needed before:** significant theme/layout work on acts_of_defiance site

**Current:** Hugo (in place, fast, zero Node.js dependency, single binary).

**Consider:** Astro — native Svelte component support, Content Collections built for markdown + typed frontmatter, TypeScript-first, excellent built-in image optimization. Shared design system components between site and dime UI is the compelling reason.

**Low-risk swap:** `PublishingAdapter` interface means an `AstroAdapter` is just a new file. Don't invest in Hugo templates until this is decided.

---

## DECISION-004: Infrastructure provider — GCP vs. managed alternatives

**Decision needed before:** first production deploy

**GCP estimate:** Cloud SQL (~$10/mo) + Memorystore (~$16/mo) ≈ $25–30/month. Single billing stack, no extra agreements.

**Alternatives if cost is a concern:**
- PostgreSQL: Neon (serverless, scales to zero, generous free tier)
- Redis: Upstash (serverless, pay-per-request, free tier)
- Both use standard wire protocols — zero code changes, connection string swap only.

---

## DECISION-005: Workflow config UI

**Decision needed before:** multi-user team workflow is needed

**Scope:** settings screen for managing workflow presets, role assignments per project, notification adapter configuration.

Not critical path. `solo` preset covers the immediate use case.

---

## DECISION-006: Slack + SMS notification adapters

---

## DECISION-007: Observability tooling — Logfire vs. alternatives

**Decision needed before:** production deployment / any serious debugging work

**Current state:** Logfire is already configured in the `dime` codebase with FastAPI and SQLAlchemy integration.

**Question:** Is Logfire still the right choice given the new architecture?

**Alternatives:**
- **OpenTelemetry + GCP Cloud Trace** — vendor-neutral, native GCP integration, no extra service
- **Sentry** — error tracking + performance, generous free tier, excellent Python/FastAPI SDK
- **Keep Logfire** — already integrated, good structured logging, works with ADK

**Consideration:** the new architecture has multiple services (API, workers, broker). Distributed tracing matters more now than in the Phase 0 single-process setup. GCP Cloud Trace + Cloud Logging is free and already in the stack.

---

## DECISION-008: Claude Code skills per layer

Existing skills: Python development, Next.js development. Need skills for:
- `dime` layer — Python/FastAPI/ADK/pyright/ruff/pytest/Bun
- `dime-ui` layer — Svelte/SvelteKit/Bun/Vitest/Storybook/Playwright
- `acts-of-defiance` layer — Hugo (now) / Astro (future)

**Options:**
- Adapt existing skills independently per repo
- Create a single meta-skill that abstracts platform tooling and detects context
- Combine into a unified `dime-dev` skill with platform-aware sections

**Action:** Design and write skills when implementation work begins. Reference existing Python and Next.js skills as starting points.

---

## DECISION-008: GitHub Projects for cross-repo issue aggregation

**Decision needed before:** team workflow is in active use

**Scope:** `SlackNotificationAdapter` and `SMSNotificationAdapter` (Twilio). Interface (`NotificationAdapter` Protocol) is already defined. Implementation is straightforward once the solo workflow is validated.

---

## DECISION-009: Integration test strategy

**Decision needed before:** implementing adapters (`implement-adapters.md`)

**Question:** Which tests require real external services, how are they gated, and what does CI provision?

**Proposed approach:**
- `@pytest.mark.integration` marker for any test requiring Postgres, Redis, or GCS
- `uv run pytest` (no args) = unit tests only, zero services required
- `uv run pytest -m integration` = requires local Postgres + Redis; GCS tests skipped unless `GCS_TEST_BUCKET` env var is set
- CI: runs integration suite with Docker-provisioned Postgres + Redis; GCS gated behind secret
- `doctor.sh` warns if Postgres or Redis are unreachable before running integration suite

**Also decide:** real GCS bucket vs. local GCS emulator (fake-gcs-server) for local integration tests.

**See:** `docs/issues/define-integration-test-strategy.md`

---

## Settled: Repository structure

```
github.com/ActsOfDefiance/
  dime-ops          ← command center: Claude home, canonical context, setup + doctor commands
  dime              ← Python agent + FastAPI
  dime-ui           ← Svelte/SvelteKit frontend
  acts-of-defiance  ← Hugo/Astro site
  compendium        ← GPLv3 markdown articles (no images)
```

**`dime-ops` is the Claude working root** for org-level and cross-repo work. It holds: `CLAUDE.md` (org-level), `docs/memory/`, `docs/specs/`, `docs/decisions/`, `docs/wireframes/`, and `setup/` scripts.

Each sibling repo has a lean repo-specific `CLAUDE.md` and symlinks for `docs/memory/`, `docs/specs/`, `docs/decisions/` pointing to `../dime-ops/docs/`. The `setup link` command in `dime-ops` creates all symlinks. The `doctor` command checks and repairs them.

**Art/images:** not in git. Generated images are artifacts stored in GCS (FileSystemAdapter). `.xcf` files ignored/untracked.

**License separation:** compendium (GPLv3) and art (CC BY-SA) intentionally separate repos.
