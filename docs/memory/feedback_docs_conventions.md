---
name: Documentation conventions
description: Rules for doc file paths, naming, and structure in this project
type: feedback
---

Do not include "superpowers" in any documentation paths. Use plain paths like `docs/specs/`, `docs/wireframes/`.

Do not include dates in filenames. They add no contextual value. Use descriptive names like `dime-design.md`, not `2026-03-28-dime-design.md`.

Tickets/open decisions do NOT belong in design docs. Design docs are reference material; tickets are actionable work items. Keep them separate — in GitHub Issues, Linear, or a dedicated decisions file.

Project memory belongs in `docs/memory/` — NEVER in `~/.claude`. No exceptions. `~/.claude` is for global tool config, not project context.

**Why:** Project memories are project-specific. Putting them in `~/.claude` leaks project context into a global location and breaks the separation between projects.
**How to apply:** Every memory read and write goes to `docs/memory/`. If the auto-memory system tries to use `~/.claude/projects/...`, override it and write to `docs/memory/` instead.
