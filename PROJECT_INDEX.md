# Project Index: dime-ops

Generated: 2026-04-05

## Project Structure

```
dime-ops/                    # Command center — no application code
├── CLAUDE.md                # Org-level Claude context (read first)
├── Justfile                 # Task runner (89 lines)
├── setup/
│   ├── doctor.sh            # Env verification (186 lines)
│   └── link.sh              # Symlink creator (94 lines)
├── .claude/
│   ├── commands/            # 4 workflow skills
│   ├── pm/                  # PM playbook + priorities
│   └── tools/               # pr-poll.sh, migrate.sh
└── docs/
    ├── specs/               # 10 architecture specs
    ├── decisions/           # Open + settled decisions
    ├── issues/              # 5 epics, ~25 sub-issues
    ├── process/             # 5 process docs
    ├── memory/              # 10 memory files
    ├── projects/            # Detailed plans
    └── wireframes/          # 4 interactive HTML diagrams
```

## Entry Points

- **Session start**: Read `CLAUDE.md` → `docs/memory/MEMORY.md`
- **Task runner**: `Justfile` — `just dev`, `just test`, `just lint`, `just doctor`
- **Env check**: `setup/doctor.sh` — verifies repos, deps, DBs, symlinks
- **Symlinks**: `setup/link.sh` — links docs/ into sibling repos
- **PR automation**: `.claude/tools/pr-poll.sh` — polls and merges PRs
- **DB migration**: `.claude/tools/migrate.sh` — Alembic wrapper

## Claude Code Skills

| Skill | File | Scope |
|-------|------|-------|
| `feature-dime` | `.claude/commands/feature-dime.md` | Python/FastAPI/ADK backend |
| `feature-dime-ui` | `.claude/commands/feature-dime-ui.md` | SvelteKit/Bun frontend |
| `feature-aod` | `.claude/commands/feature-aod.md` | Astro+Svelte5 publication site |
| `pm` | `.claude/commands/pm.md` | Project management (triage, status, next) |

## Specs (docs/specs/)

| File | Topic |
|------|-------|
| `dime-overview.md` | System principles, markdown-first, adapter pattern |
| `dime-architecture.md` | 4-layer: agents → API → adapters → infra |
| `dime-pipeline.md` | 11-state content pipeline state machine |
| `dime-data-model.md` | PostgreSQL schema (8 tables) |
| `dime-agents.md` | 5 ADK agents: Research, Writer, ArtDirector, Image, Publisher |
| `dime-ui.md` | Two-pane chat dashboard |
| `dime-deployment.md` | Local dev + GCP Cloud Run |
| `dime-workflows.md` | Agent orchestration |
| `pm-agent.md` | PM agent design |
| `design-standards.md` | WCAG 2.2 AA, performance requirements |

## Active State

**Active epic**: epic-dime-core
**Current focus**: implement-pipeline (#17), write-agent-prompts (#12), implement-astro-adapter (#19)
**Priorities file**: `.claude/pm/priorities.md`
**Playbook**: `.claude/pm/playbook.md`

### Key Decisions

| ID | Status | Choice |
|----|--------|--------|
| D-001 | Settled | Filesystem canonical, git versioning |
| D-002 | Settled | shadcn-svelte + Tailwind (dime-ui) |
| D-003 | Settled | Astro + Svelte 5 (acts-of-defiance) |
| D-004 | Open | GCP vs Neon/Upstash (infra) |
| D-007 | Open | Logfire vs OTel vs Sentry (observability) |
| D-008 | Settled | One Claude skill per layer |
| D-009 | Settled | pytest markers, real DB integration tests |

## Sibling Repos

| Repo | GitHub | Stack | Status |
|------|--------|-------|--------|
| `dime` | ActsOfDefiance/dime | Python 3.13, FastAPI, ADK, uv | Active |
| `dime-ui` | ActsOfDefiance/dime-ui | SvelteKit, Bun | Not yet scaffolded |
| `acts-of-defiance` | ActsOfDefiance/acts-of-defiance | Astro + Svelte 5 | Active |
| `compendium` | ActsOfDefiance/compendium | Markdown (GPLv3) | Content repo |

## File Counts

- Specs: 10 files
- Decisions: 3 files (open, settled, labels)
- Issues: 30 files (5 epics + 25 sub-issues)
- Process: 5 files
- Memory: 10 files
- Wireframes: 4 HTML files
- Scripts: 5 files (566 lines total)
- Config: Justfile, .gitignore, .claudeignore, settings.local.json
