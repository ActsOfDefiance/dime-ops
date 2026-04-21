# Issue: Create and configure dime-ops repo

**Type:** infrastructure
**Priority:** high — blocks all multi-repo work
**Repo:** dime-ops (to be created at github.com/ActsOfDefiance/dime-ops)

## What dime-ops is

The command center and canonical context home for the ActsOfDefiance org. See `docs/decisions/open-decisions.md` (settled: repository structure).

## Tasks

### Repo setup
- [x] Create repo at github.com/ActsOfDefiance/dime-ops
- [x] Set up Gitflow branch protection (main, develop protected)
- [x] Add LICENSE (GPLv3)
- [x] Add `docs/memory/local_config.md` to `.gitignore` — this file holds machine-local values (GCP project ID, etc.) that must never be committed

### Directory structure
```
dime-ops/
  CLAUDE.md              ← org-level Claude context
  .claudeignore          ← excludes .venv/, node_modules/, __pycache__/, .git/, build artifacts
  docs/
    memory/              ← migrate from current ActsOfDefiance/docs/memory/
    specs/               ← migrate from current ActsOfDefiance/docs/specs/
    decisions/           ← migrate from current ActsOfDefiance/docs/decisions/
    wireframes/          ← migrate from current ActsOfDefiance/docs/wireframes/
    issues/              ← migrate from current ActsOfDefiance/docs/issues/
    projects/            ← migrate from current ActsOfDefiance/docs/projects/
  setup/
    link.sh              ← creates symlinks in sibling repos
    doctor.sh            ← checks and repairs setup issues
  .gitignore
  README.md
```

### link.sh
Script that, when run from `dime-ops/`, creates the following symlinks in each sibling repo and ensures a `.claudeignore` exists in each:
```
../dime/docs/memory      → ../../dime-ops/docs/memory
../dime/docs/specs       → ../../dime-ops/docs/specs
../dime/docs/decisions   → ../../dime-ops/docs/decisions
../dime-ui/docs/memory   → ../../dime-ops/docs/memory
(etc. for each repo)
```
Must be idempotent (safe to run multiple times).

### doctor.sh
Checks:
- [x] All expected sibling repos are present
- [ ] All symlinks exist and point to valid targets
- [ ] Python version meets requirements
- [ ] uv is installed
- [ ] Bun is installed
- [ ] Required environment variables are set
- [ ] Local Postgres is reachable
- [ ] Local Redis is reachable
- [ ] Git user config is set
- [ ] Gitflow hooks are in place

Reports clearly: ✓ OK / ✗ FAIL / ⚑ WARNING with fix instructions for each failure.

### CLAUDE.md (org-level)
- What this org is building
- Repo structure and what each repo does
- Where specs live
- Gitflow rules
- Key decisions summary (link to docs/decisions/)
- How to run Claude for cross-repo vs. focused work

## Migration note

Current working docs in `ActsOfDefiance/docs/` move to `dime-ops/docs/` when this repo is created. The current top-level working directory becomes a sibling container only.

## Sync to GitHub: this IS the GitHub setup task
