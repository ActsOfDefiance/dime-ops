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

**Currently:** still working in the local mono-repo at top level. Migration to multi-repo is a future task. docs/ here will move to dime-ops.

**Architecture decisions:** see `docs/specs/` for full specs per layer.

**Why:** To separate concerns cleanly — dime writes markdown; the site reads it; publishing is a signal. The agent never touches the website.
**How to apply:** Always reference `docs/specs/` before suggesting architecture changes. Existing compendium articles + art assets are the first test cases for the pipeline.
