# CLAUDE.md — Acts of Defiance Org

This is the org-level Claude context. Open Claude from this directory for cross-repo work (architecture, decisions, epics). For focused implementation work, open Claude from the relevant repo.

## Session start

Read `docs/memory/MEMORY.md` at the start of every session to load project context, user preferences, and working conventions.

## What we're building

**dime** (Dime Store Novel) — an AI agent-driven publishing system. It researches topics, composes articles, generates graphics, and publishes to a static site via a pluggable adapter pattern.

**Acts of Defiance** — a political publication for liberal adults 20–40. dime is its production engine.

## Repo structure

| Repo | Purpose | Stack |
|---|---|---|
| `dime-ops` | Command center: specs, decisions, tooling | shell, just |
| `dime` | Python backend: FastAPI API, ADK agents, pipeline | Python 3.13, uv, FastAPI, ADK |
| `dime-ui` | Chat dashboard frontend | Svelte/SvelteKit, Bun |
| `acts-of-defiance` | The publication | Hugo (evaluating Astro) |
| `compendium` | Canonical article content | Markdown, GPLv3 |

All repos are siblings locally:
```
ActsOfDefiance/
  dime-ops/
  dime/
  dime-ui/
  acts-of-defiance/
  compendium/
```

## Where context lives

All specs, decisions, wireframes, issues, and memory live in `dime-ops/docs/`. Sibling repos symlink to this directory. Run `just link` to create symlinks. Run `just doctor` to verify.

Key docs:
- `docs/specs/dime-overview.md` — system overview and principles
- `docs/specs/dime-architecture.md` — 4-layer architecture
- `docs/specs/dime-pipeline.md` — 11-state content pipeline
- `docs/specs/dime-data-model.md` — PostgreSQL schema
- `docs/specs/dime-agents.md` — ADK agent design
- `docs/specs/dime-ui.md` — Svelte UI design
- `docs/specs/dime-deployment.md` — local dev and GCP production
- `docs/decisions/open-decisions.md` — all pending decisions (DECISION-001 through DECISION-009)
- `docs/issues/epic-*.md` — implementation epics and sub-issues

## Gitflow rules

- **Never work in `main` or `develop` directly**
- All work in `feature/`, `hotfix/`, or `release/` branches
- PRs required to merge into `develop` or `main`
- `main` and `develop` are protected — no direct pushes
- Commit messages: imperative mood, present tense ("Add adapter" not "Added adapter")

## Tech stack

| Concern | Choice | Notes |
|---|---|---|
| Python backend | FastAPI + Google ADK | Agents are ADK LlmAgents |
| Python tooling | uv, ruff, pyright, pytest | No mypy, no pip directly |
| Frontend | Svelte/SvelteKit + Bun | No React, no Node/npm |
| Frontend testing | Vitest + Storybook + Playwright | |
| Database | PostgreSQL + SQLAlchemy + Alembic | |
| Broker | Redis (pluggable) | RabbitMQ / GCP Pub/Sub via adapter |
| Image generation | Imagen 3 | |
| Image storage | GCS | Not git — images are artifacts |
| SSG | Hugo → evaluating Astro | See DECISION-003 |
| Deployment | Cloud Run + Cloud Run Jobs | GCP, ~$25-30/month |
| Observability | Logfire | Pending DECISION-007 |
| Commands | just | Justfile in dime-ops root |

## Secrets

- Secrets live in `.envrc` only — never `.env`, never committed
- GCP project ID: `actsofdefiance` (local config — see `docs/memory/local_config.md`)
- `.envrc` is gitignored in all repos

## Cross-repo vs focused work

| Task | Open Claude from |
|---|---|
| Architecture, decisions, epics | `dime-ops/` |
| Python backend, agents, API | `dime/` |
| Svelte frontend | `dime-ui/` |
| Site, publishing, Hugo | `acts-of-defiance/` |
| Article content | `compendium/` |
