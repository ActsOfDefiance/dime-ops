# dime-ops

Command center for the [Acts of Defiance](https://github.com/ActsOfDefiance) org. Canonical home for architecture specs, decisions, project memory, and development tooling.

## Requirements

- [just](https://just.systems) — command runner (`brew install just` or see [installation](https://just.systems/man/en/installation.html))
- [uv](https://docs.astral.sh/uv/) — Python package manager
- [Bun](https://bun.sh) — JavaScript runtime and package manager
- Python 3.13+
- PostgreSQL (local)
- Redis (local)

## Setup

```bash
just link     # create symlinks in sibling repos
just doctor   # verify full environment
```

## Commands

```bash
just          # list all available commands
just doctor   # check environment health
just link     # create/repair symlinks in sibling repos
just dime-dev      # start dime API server
just dime-test     # run dime test suite
just ui-dev        # start dime-ui dev server
just site-dev      # start acts-of-defiance Hugo server
```

## Structure

```
dime-ops/
  docs/
    specs/       ← architecture specs (symlinked into sibling repos)
    decisions/   ← open and settled decisions
    issues/      ← epics and tickets
    memory/      ← Claude project memory
    wireframes/  ← UI wireframes
    projects/    ← per-project editorial config
  setup/
    link.sh      ← creates symlinks in sibling repos
    doctor.sh    ← checks and repairs the full setup
  Justfile       ← all commands live here
  CLAUDE.md      ← org-level Claude context
```

## Repos

| Repo | Purpose |
|---|---|
| [dime-ops](https://github.com/ActsOfDefiance/dime-ops) | This repo — command center |
| [dime](https://github.com/ActsOfDefiance/dime) | Python backend: agents, API, pipeline |
| [dime-ui](https://github.com/ActsOfDefiance/dime-ui) | Svelte frontend |
| [acts-of-defiance](https://github.com/ActsOfDefiance/acts-of-defiance) | Hugo/Astro publication site |
| [compendium](https://github.com/ActsOfDefiance/compendium) | Canonical article content (GPLv3) |
