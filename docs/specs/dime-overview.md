# Dime — Overview & Principles

Dime is a general-purpose, AI-agent-driven publishing pipeline. It researches topics, composes articles, generates art briefs and images, and publishes to configured targets. Dime is completely decoupled from the content it produces and the platform it publishes to.

## Core Principles

- Markdown with YAML frontmatter is the canonical content format. Always.
- The filesystem (`compendium/`, `art/`) is the source of truth for content. The database tracks state, metadata, and events.
- All infrastructure (broker, filesystem, publishing, notifications) is hidden behind swappable adapter interfaces.
- Agents are discrete, bounded tasks — they run to completion and exit. No agent waits for a human.
- The presentation layer (Svelte UI) is fully decoupled — it speaks REST + WebSocket to the API and knows nothing about agent internals.

## Repository Structure

```
ActsOfDefiance/          ← working mono-repo during development
  dime/                  ← the agent system
  acts_of_defiance/      ← Astro static site (first publish target)
  compendium/            ← canonical markdown articles (git repo, source of truth)
  art/                   ← image assets produced by dime
  docs/
    specs/               ← architecture and design specs (this directory)
    wireframes/          ← HTML wireframes
    decisions/           ← open decisions and deferred choices
    memory/              ← project context for AI-assisted development
```

Separation of concerns is intentional. Dime writes to `compendium/` and `art/`. The website reads from them. Dime never reaches into the website.

## Related Specs

- [Architecture](dime-architecture.md) — system layers, adapters, component map
- [Pipeline](dime-pipeline.md) — content state machine, human checkpoints
- [Data Model](dime-data-model.md) — PostgreSQL schema
- [Agents](dime-agents.md) — ADK agent structure and tools
- [UI](dime-ui.md) — Svelte frontend, two-pane layout
- [Deployment](dime-deployment.md) — local dev, GCP production, CI/CD
- [Workflows](dime-workflows.md) — roles, notifications, presets
