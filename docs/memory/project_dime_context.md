---
name: Dime project context
description: Core context for the Acts of Defiance / dime publishing agent project — architecture, decisions, stack, repo structure
type: project
---

Dime is a general-purpose AI-agent-driven publishing pipeline (research → write → art → publish). It is completely decoupled from the content/topic it produces. The real-world project it is being built for is "Acts of Defiance" — a political history site.

**Design specs:** `docs/specs/` (split into focused files per layer)
**Wireframes:** `docs/wireframes/`
**Open decisions:** `docs/decisions/open-decisions.md`

**GitHub org:** https://github.com/ActsOfDefiance

**Multi-repo structure (github.com/ActsOfDefiance/):**
- `dime-ops` — Claude home, canonical context (CLAUDE.md, docs/memory/, docs/specs/), setup + doctor commands
- `dime` — Python agent + FastAPI + Google ADK
- `dime-ui` — Svelte/SvelteKit frontend (separate repo, separate deploy cycle)
- `acts-of-defiance` — Hugo/Astro site
- `compendium` — GPLv3 markdown articles (no images, own git history)
- Images: NOT in git — GCS bucket via FileSystemAdapter

**Symlink convention:** each sibling repo symlinks docs/memory/, docs/specs/, docs/decisions/ → ../dime-ops/docs/. `dime-ops/setup/link.sh` creates them. `dime-ops/setup/doctor.sh` verifies and repairs.

**Current epic:** epic-dime-core — implementing the actual product.

**Settled decisions (as of 2026-03-31):**
- DECISION-001: Filesystem canonical, git as versioning layer. DB stores git commit hash pointer in `article_checkpoint`. Content snapshot only at publish time.
- DECISION-008: Three Claude Code layer skills (feature-dime, feature-dime-ui, feature-aod) in `dime-ops/.claude/commands/`, symlinked into each repo via `setup/link.sh`.
- DECISION-009: Integration test strategy — `@pytest.mark.integration` for real-service tests; `uv run pytest` = unit only; CI uses Docker-provisioned Postgres + Redis.

**dime-core progress (as of 2026-03-31):**
- ✅ configure-dime-project-deps (#20) — deps, Alembic, pyright, pytest markers, dir stubs
- ✅ implement-db-schema (#14) — SQLAlchemy models + Alembic migrations
- ✅ implement-adapters (#15) — BrokerAdapter, FileSystemAdapter, PublishingAdapter, NotificationAdapter
- 🔄 implement-api-layer (#16) — in progress
- ⬜ implement-hugo-adapter (#19) — unblocked
- ⬜ write-agent-prompts (#12) — unblocked
- ⬜ implement-pipeline (#17) — blocked on #16
- ⬜ implement-agents (#18) — blocked on #17 + #12

**PM tooling:**
- `/pm` skill in `dime-ops/.claude/commands/pm.md` — triage, promote, next, status, roadmap, audit, retro
- Playbook: `.claude/pm/playbook.md`; Priorities: `.claude/pm/priorities.md`
- GitHub is canonical for active issues; local `docs/issues/` is planning only
- Feature skills read issues via `gh issue view {N} --repo ActsOfDefiance/{repo}` and include `Closes #N` in PR bodies

**dime-ops PR #1** (`feature/complete-ops-setup-epic` → `develop`) — open, all review feedback addressed, ready to merge.

**Architecture decisions:** see `docs/specs/` for full specs per layer.

**Why:** To separate concerns cleanly — dime writes markdown; the site reads it; publishing is a signal. The agent never touches the website.
**How to apply:** Always reference `docs/specs/` before suggesting architecture changes. Existing compendium articles + art assets are the first test cases for the pipeline.
