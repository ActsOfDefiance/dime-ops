# Issue: Create Claude Code skills for each project layer

**Type:** tooling / developer experience
**Priority:** medium — do before active implementation begins on each layer
**Repo:** dime-ops

## Context

See `docs/decisions/open-decisions.md` DECISION-008.

Existing skills available: Python development, Next.js development. These need to be adapted and/or new skills created for each layer of this project.

## Layers requiring skills

**`dime` layer (Python)**
- Tools: uv, ruff, pyright, pytest
- Patterns: ADK agent structure, adapter interfaces, FastAPI + WebSocket
- Adapt from: existing Python skill

**`dime-ui` layer (Svelte/TypeScript)**
- Tools: bun, ESLint, Prettier, Vitest, Storybook, Playwright
- Patterns: SvelteKit routing, two-pane chat UI, WebSocket state management
- Adapt from: existing Next.js skill (tooling differs significantly — Bun not Node)

**`acts-of-defiance` layer (Astro + Svelte 5)**
- Tools: Astro + Bun
- Patterns: content collections, markdown frontmatter, publishing adapter signals
- New skill (no existing equivalent)

## Decision: single unified skill vs. per-layer skills

A single meta-skill that detects context (what repo am I in?) and activates the right tooling section. Or three separate skills invoked per context.

Recommendation: three separate skills — cleaner, easier to update independently, less cognitive load. A root CLAUDE.md in `dime-ops` can reference all three so Claude knows which to invoke.

## Reference

Existing skills location: `~/.claude/plugins/` (check for Python and Next.js skill locations before writing new ones to avoid duplication)

## Sync to GitHub: yes (dime-ops repo)
