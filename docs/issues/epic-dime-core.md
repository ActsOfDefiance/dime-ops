# Epic: Dime Core

**Type:** feature
**Priority:** high — the actual product
**Blocked by:** epic-ops-setup (needs repo + CLAUDE.md in place)

## Goal

A working content pipeline: from project creation through research, writing, art direction, image generation, and publish signal to the static site. All adapters pluggable. State machine enforced. Runs locally without Docker.

## Sub-issues

### Foundation (no dependencies on each other)
- [ ] [implement-db-schema.md](implement-db-schema.md) — PostgreSQL tables: project, article, article_checkpoint, image_slot, image_variant, publish_event, user, role, workflow_config
- [ ] [implement-adapters.md](implement-adapters.md) — BrokerAdapter (Redis default), FileSystemAdapter (local + GCS), PublishingAdapter (Hugo signal), NotificationAdapter

### API layer
- [ ] [implement-api-layer.md](implement-api-layer.md) — FastAPI: project CRUD, article CRUD, pipeline state transitions, WebSocket push, content_guide endpoint
- [ ] [implement-pipeline.md](implement-pipeline.md) — 11-state machine, human checkpoint gates, worker dispatch via broker

### Agent layer (depends on: adapters + pipeline)
- [ ] [write-agent-prompts.md](write-agent-prompts.md) — existing ticket; prompts for all 4 LLM agents
- [ ] [implement-agents.md](implement-agents.md) — ADK LlmAgents (Research, Writer, ArtDirector, Image) + PublisherAgent; content_guide injection; tool implementations

### Publishing
- [ ] [implement-hugo-adapter.md](implement-hugo-adapter.md) — PublishingAdapter for Hugo: markdown emit, frontmatter, signal file, GCS image download

### Decisions to resolve during this epic
- [ ] DECISION-001: Article versioning strategy (git pointer vs DB snapshot) — resolve before implementing FileSystemAdapter
- [ ] DECISION-007: [decide-observability-tooling.md](decide-observability-tooling.md) — resolve before production, but don't block development
- [ ] DECISION-009: [define-integration-test-strategy.md](define-integration-test-strategy.md) — resolve before implementing adapters; defines pytest markers, which tests require real services, and how CI gates GCS tests

## Order

```
implement-db-schema
implement-adapters (BrokerAdapter + FileSystemAdapter first)
    ↓
implement-api-layer
implement-pipeline
    ↓
write-agent-prompts
    ↓
implement-agents
    ↓
implement-hugo-adapter
```

## Definition of Done

- [ ] `uv run pytest` passes (unit + integration with real Postgres + Redis)
- [ ] `uv run pyright` no errors
- [ ] `uv run ruff check` clean
- [ ] Pipeline can take an article from `queued` → `published` end-to-end locally
- [ ] Hugo adapter emits valid markdown + frontmatter to compendium/
- [ ] All adapters injectable via config (no hardcoded Redis or filesystem paths)
- [ ] content_guide data from project.content_guide injected into agent context
- [ ] Human checkpoint gates actually block pipeline until approved via API
