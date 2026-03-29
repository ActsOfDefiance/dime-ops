# dime-ops

Command center for dime, the Dime Content Management System. Canonical home for architecture specs, decisions, project memory, and development tooling.

## Requirements

- [just](https://just.systems) — command runner (`brew install just` or see [installation](https://just.systems/man/en/installation.html))
- [uv](https://docs.astral.sh/uv/) — Python package manager
- [Bun](https://bun.sh) — JavaScript runtime and package manager
- Python 3.13+
- PostgreSQL (local)
- Redis (local)

## Getting started

### 1. Clone all repos as siblings

```bash
mkdir -p ActsOfDefiance && cd ActsOfDefiance
git clone git@github.com:ActsOfDefiance/dime-ops.git
git clone git@github.com:ActsOfDefiance/dime.git
git clone git@github.com:ActsOfDefiance/acts-of-defiance.git
git clone git@github.com:ActsOfDefiance/compendium.git
```

You should have:
```
ActsOfDefiance/
  dime-ops/
  dime/
  acts-of-defiance/
  compendium/
```

### 2. Install prerequisites

Linux ([Homebrew](https://docs.brew.sh/Homebrew-on-Linux)) and macOS ([Homebrew](https://brew.sh)):

```bash
brew install just uv bun direnv postgresql redis
```

> For other distros or package managers, see each tool's install docs ([just](https://just.systems/man/en/installation.html), [uv](https://docs.astral.sh/uv/), [bun](https://bun.sh), [direnv](https://direnv.net)). For Windows, see [S.E.P. fields](https://hitchhikers.fandom.com/wiki/Somebody_Else%27s_Problem_Field).

Start services:
```bash
brew services start postgresql   # or: sudo systemctl start postgresql
brew services start redis        # or: redis-server --daemonize yes
```

### 3. Create the dime database

```bash
createuser dime_user
createdb -O dime_user dime_dev
psql -c "ALTER USER dime_user WITH PASSWORD 'dime_password';"
```

### 4. Configure secrets

```bash
cd dime
cp .envrc.example .envrc
# Edit .envrc — fill in your GOOGLE_ADK_API_KEY and LOGFIRE_TOKEN
direnv allow
```

### 5. Install dependencies

```bash
cd dime && uv sync && cd ..
```

### 6. Link and verify

```bash
cd dime-ops
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
| [acts-of-defiance](https://github.com/ActsOfDefiance/acts-of-defiance) | Example publishing target (Hugo/Astro) — optional, for reference |
| [compendium](https://github.com/ActsOfDefiance/compendium) | Document store for article content (GPLv3) — optional, for reference |
