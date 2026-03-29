# Issue: Rewrite dime/CLAUDE.md

**Type:** maintenance
**Priority:** high — do before any implementation work begins in the dime repo
**Repo:** dime

## Problem

`dime/CLAUDE.md` reflects the old Phase 0 architecture and outdated tooling:
- References 7-stage pipeline (fact checker, editor, assembly) — replaced by new 4-agent design
- References mypy — replaced by pyright
- References old project structure (publisher/ legacy code, old docs/ layout)
- Contains github_issues/ reference in file tree
- No mention of new adapter pattern (BrokerAdapter, FileSystemAdapter, PublishingAdapter)

## What it should become

A lean repo-specific CLAUDE.md covering only what is unique to the `dime` repo:
- Python/uv/ruff/pyright/pytest commands
- Current file structure (actual, post-refactor)
- Gitflow rules (no work in main/develop)
- Pointer to `../dime-ops/docs/` for architecture specs and org context (via symlink once dime-ops is set up)

The coding standards and git workflow sections are still valid — keep those.

## When to do this

When beginning the dime implementation sprint (after dime-ops repo is set up and symlinks are in place).

## Also

- [ ] Verify `.claudeignore` exists in repo root — excludes `.venv/`, `__pycache__/`, `node_modules/`, `.git/`, `htmlcov/`, build artifacts (already created; confirm it's committed)

## Sync to GitHub: yes
