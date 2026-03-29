# Epic: Ops & Setup

**Type:** infrastructure
**Priority:** highest — must complete before any other epic begins
**Blocks:** everything

## Goal

Establish the multi-repo structure, project management home (dime-ops), and a clean GitHub presence. All active development work lives in organized repos with proper context, tooling, and protection.

## Sub-issues

### Immediate (do before any GitHub push)
- [ ] [rotate-exposed-api-key.md](rotate-exposed-api-key.md) — **CRITICAL**

### GitHub audit
- [x] [review-existing-github-setup.md](review-existing-github-setup.md) — understand current state before creating anything

### dime-ops creation
- [x] [create-dime-ops-repo.md](create-dime-ops-repo.md) — canonical context home; blocks multi-repo migration

### Multi-repo migration
- [x] [multi-repo-migration.md](multi-repo-migration.md) — push dime, acts-of-defiance, compendium to GitHub; set up symlinks
- [x] [fix-readme-merge-conflicts.md](fix-readme-merge-conflicts.md) — clean up dime README before first push

### Repo housekeeping (can run in parallel with dime-ops)
- [x] [rewrite-dime-readme.md](rewrite-dime-readme.md)
- [x] [rewrite-dime-claude-md.md](rewrite-dime-claude-md.md)

### Developer tooling
- [x] [create-layer-skills.md](create-layer-skills.md) — Claude Code skills for dime, dime-ui, acts-of-defiance layers; do before active implementation begins

## Order

```
rotate-exposed-api-key
    ↓
review-existing-github-setup
    ↓
create-dime-ops-repo
    ↓
multi-repo-migration (+ fix-readme-merge-conflicts)
    ↓ (parallel with migration)
rewrite-dime-readme + rewrite-dime-claude-md
    ↓
create-layer-skills
```

## Definition of Done

- [ ] No secrets in any repo history
- [ ] GitHub org has 4 repos (dime-ops, dime, acts-of-defiance, compendium)
- [ ] dime-ops is canonical docs home; sibling repos have symlinks to it
- [ ] All repos have Gitflow branch protection (main + develop protected)
- [ ] dime README and CLAUDE.md reflect current architecture
- [ ] Claude Code skills available for each layer
- [ ] `dime-ops/setup/doctor.sh` passes all checks
