# Issue: Migrate from working mono-repo to multi-repo structure

**Type:** infrastructure
**Priority:** medium — do after dime-ops is set up
**Repo:** dime-ops

## Context

Currently all work lives in a single local directory (`ActsOfDefiance/`). The agreed structure is five separate repos under `github.com/ActsOfDefiance/`. This issue tracks the migration.

## Repos to create / migrate

| Repo | Source | Notes |
|---|---|---|
| `dime-ops` | `ActsOfDefiance/docs/` + new setup scripts | Create first — see create-dime-ops-repo issue |
| `dime` | `ActsOfDefiance/dime/` | Already has git history — push to new remote |
| `dime-ui` | New | No existing code yet |
| `acts-of-defiance` | `ActsOfDefiance/acts_of_defiance/` | Has git history |
| `compendium` | `ActsOfDefiance/compendium/` | Has git history, CC BY-SA 4.0 |

## Tasks

- [x] Create `dime-ops` repo (see create-dime-ops-repo issue)
- [x] Push `dime/` history to `github.com/ActsOfDefiance/dime` — local reset to origin/develop, now in sync
- [x] Push `acts_of_defiance/` history to `github.com/ActsOfDefiance/acts-of-defiance`
- [x] Push `compendium/` history to `github.com/ActsOfDefiance/compendium`
- [x] Remove `acts_of_defiance.old/` — abandoned Django app, no value
- [x] Run `dime-ops/setup/link.sh` to create symlinks in all repos
- [x] Run `dime-ops/setup/doctor.sh` to verify everything is connected
- [x] Update local git remotes for any repos previously pointing elsewhere

## Order

1. `create-dime-ops-repo` first
2. `review-existing-github-setup` — audit what's already at ActsOfDefiance org
3. Then migrate in order: dime → acts-of-defiance → compendium

## Sync to GitHub: yes (dime-ops)
