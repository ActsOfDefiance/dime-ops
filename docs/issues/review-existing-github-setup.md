# Issue: Review existing GitHub org setup and make decisions

**Type:** planning
**Priority:** high — do before creating new repos
**Repo:** dime-ops (once created)

## Problem

There is an existing GitHub organization at https://github.com/ActsOfDefiance with unknown current state. Before creating new repos and migrating work, we need to understand what's already there.

## Findings

### Repos
| Repo | Default branch | Action taken |
|---|---|---|
| `ActsOfDefiance/dime` | `develop` | Keep — push local history here |
| `ActsOfDefiance/compendium` | `main` | Keep as-is |
| `ActsOfDefiance/website` | `main` | Renamed → `acts-of-defiance` ✓ |

**Still to create:** `dime-ops`, `dime-ui`

### Branch protection
- `dime/main` has required status check (`test`) — no Gitflow protection on `develop` yet
- Gitflow protection (main + develop) to be configured as part of `create-dime-ops-repo` and `multi-repo-migration`

### GitHub Projects
- Token lacks `read:project` scope — could not audit. Set up org-level Project as part of `create-dime-ops-repo`.
- Decision: GitHub Projects for cross-repo aggregation (agreed, see open-decisions.md)

### Org settings
- All repos public — intentional, open source from day one
- Visibility default: public

## Tasks

- [x] Audit existing repos
- [x] Decide: rename `website` → `acts-of-defiance`
- [x] Decide: all repos public
- [ ] Set up org-level GitHub Project — deferred to `create-dime-ops-repo`
- [ ] Org-level label taxonomy — deferred to `create-dime-ops-repo`
- [ ] Gitflow branch protection on all repos — deferred to `multi-repo-migration`

## Sync to GitHub: yes — create in dime-ops once that repo exists
