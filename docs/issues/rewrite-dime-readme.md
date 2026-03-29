# Issue: Rewrite dime/README.md

**Type:** maintenance
**Priority:** high — blocker for new contributors, bad first impression
**Repo:** dime

## Problem

`dime/README.md` has unresolved git merge conflict markers and describes the old Phase 0 / 7-stage architecture. It must not be the face of the repo when new contributors arrive.

## What it should become

A concise README covering:
- What dime is (one paragraph — general-purpose AI publishing pipeline)
- What it is NOT (not tied to any specific topic or publication)
- Quick start (prerequisites, clone, `uv sync`, `uv run python -m dime health`)
- Link to `docs/specs/dime-overview.md` for architecture
- Link to `../dime-ops/` for full setup

## When to do this

Before any new work is merged to the `dime` repo. Resolve conflicts first (can be done now on the existing codebase).

## Sync to GitHub: yes
