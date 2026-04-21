# dime-ops Project Index

Command center for the dime ecosystem — specs, decisions, issues, tooling, and project memory.

## Specifications (`docs/specs/`)

| Document | Purpose |
|----------|---------|
| [dime-overview.md](specs/dime-overview.md) | System overview, core principles, markdown-first philosophy |
| [dime-architecture.md](specs/dime-architecture.md) | 4-layer architecture: agents, API, adapters, infrastructure |
| [dime-pipeline.md](specs/dime-pipeline.md) | 11-state content pipeline state machine |
| [dime-data-model.md](specs/dime-data-model.md) | PostgreSQL schema and domain model |
| [dime-agents.md](specs/dime-agents.md) | ADK agent design: Research, Writer, ArtDirector, Image, Publisher |
| [dime-ui.md](specs/dime-ui.md) | Svelte chat dashboard UI specification |
| [dime-deployment.md](specs/dime-deployment.md) | Local dev setup and GCP Cloud Run production |
| [dime-workflows.md](specs/dime-workflows.md) | Multi-agent orchestration workflows |
| [pm-agent.md](specs/pm-agent.md) | Project management agent design |
| [design-standards.md](specs/design-standards.md) | WCAG 2.2 AA compliance, performance requirements |

## Decisions (`docs/decisions/`)

| Document | Purpose |
|----------|---------|
| [open-decisions.md](decisions/open-decisions.md) | Pending architectural decisions (D-004 through D-010) |
| [settled-decisions.md](decisions/settled-decisions.md) | Resolved decisions with rationale |
| [github-label-taxonomy.md](decisions/github-label-taxonomy.md) | Label system for GitHub issues and PRs |

### Settled
- **DECISION-001**: Content versioning — filesystem canonical, git as versioning layer
- **DECISION-002**: UI framework — shadcn-svelte + Tailwind for dime-ui
- **DECISION-003**: Static site generator — Astro + Svelte 5 for acts-of-defiance
- **DECISION-008**: Claude Code skills — one per layer (feature-dime, feature-dime-ui, feature-aod)
- **DECISION-009**: Integration test strategy — pytest markers, real DB for integration tests

### Open
- **DECISION-004**: Infrastructure provider — GCP vs. managed alternatives (Neon, Upstash)
- **DECISION-005**: Workflow config UI — deferred until multi-user needed
- **DECISION-006**: Slack + SMS notification adapters — deferred until multi-user needed
- **DECISION-007**: Observability tooling — Logfire vs. OpenTelemetry vs. Sentry
- **DECISION-010**: GitHub Projects for cross-repo aggregation — deferred until second contributor

## Epics & Issues (`docs/issues/`)

### epic-ops-setup (complete)
Repo structure, GitHub setup, developer tooling, Claude context.

### epic-dime-core (active)
Python backend: database, adapters, API, pipeline, agents, publishing.

| Issue | Status | GitHub |
|-------|--------|--------|
| configure-dime-project-deps | done | #20 closed |
| implement-db-schema | done | #14 closed |
| implement-adapters | done | #15 closed |
| implement-api-layer | done | #16 closed |
| implement-pipeline | open | #17 |
| write-agent-prompts | open | #12 |
| implement-agents | blocked (#17 + #12) | #18 |
| implement-astro-adapter | open | #19 |

### epic-dime-ui (blocked on scaffold)
Svelte chat dashboard: scaffold, left pane, right pane, package dashboard.

| Issue | Status |
|-------|--------|
| scaffold-dime-ui | unblocked (DECISION-002 settled) |
| implement-left-pane | blocked (scaffold) |
| implement-right-pane | blocked (scaffold) |
| implement-package-dashboard | blocked (scaffold) |

### epic-acts-of-defiance
Publication site: Astro setup, tile designs.

| Issue | Status |
|-------|--------|
| set-up-acts-of-defiance-site | unblocked (DECISION-003 settled) |
| Tile Designs | open (GitHub #1) |

### epic-production
GCP infrastructure, CI/CD, observability.

| Issue | Status |
|-------|--------|
| set-up-gcp-infra | blocked (DECISION-004) |
| set-up-ci-cd | open |
| decide-observability-tooling | open (DECISION-007) |

## Wireframes (`docs/wireframes/`)

Interactive HTML visualizations — open in a browser.

| File | Shows |
|------|-------|
| [dime-architecture-options.html](wireframes/dime-architecture-options.html) | Architecture layer diagram |
| [dime-data-model.html](wireframes/dime-data-model.html) | Entity relationship diagram |
| [dime-pipeline-state-machine.html](wireframes/dime-pipeline-state-machine.html) | 11-state pipeline flow |
| [dime-ui-chat-panes.html](wireframes/dime-ui-chat-panes.html) | Chat UI two-pane layout |

## Process (`docs/process/`)

| Document | Purpose |
|----------|---------|
| [decision-making.md](process/decision-making.md) | DECISION format, consensus process |
| [definition-of-done.md](process/definition-of-done.md) | DoD checklist for issues |
| [issue-lifecycle.md](process/issue-lifecycle.md) | Triage → in-progress → review → merge |
| [sprint-planning.md](process/sprint-planning.md) | Sprint structure |
| [triage.md](process/triage.md) | Issue triage and priority assignment |

## Claude Code Workflows (`.claude/`)

| Skill | Scope |
|-------|-------|
| `feature-dime` | Python/FastAPI/ADK — ruff, pyright, pytest 90% coverage |
| `feature-dime-ui` | SvelteKit/Bun — ESLint, Prettier, Vitest, Playwright |
| `feature-aod` | Astro + Svelte 5 — publication site |
| `pm` | Project manager — triage, priorities, roadmap, decisions |

## Tooling

| File | Purpose |
|------|---------|
| `Justfile` | Command runner for all repos (dev, test, build, CI) |
| `setup/doctor.sh` | Verifies full dev environment (repos, deps, DBs, symlinks) |
| `setup/link.sh` | Creates symlinks to `docs/` in sibling repos |
| `.claude/tools/pr-poll.sh` | GitHub PR polling and merge automation |
| `.claude/tools/migrate.sh` | Database migration utilities |

## Repo Map

```
ActsOfDefiance/
├── dime-ops/      ← you are here (command center)
├── dime/          ← Python backend (FastAPI, ADK agents)
├── dime-ui/       ← Svelte chat dashboard
├── acts-of-defiance/ ← Astro publication site
└── compendium/    ← Canonical article content (Markdown, GPLv3)
```

All sibling repos symlink `docs/` back to `dime-ops/docs/` for shared specs, decisions, and memory.
