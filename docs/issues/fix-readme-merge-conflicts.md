# Issue: Fix README merge conflicts

**Type:** housekeeping
**Priority:** high — must resolve before first push to GitHub
**Repo:** dime
**Epic:** epic-ops-setup

## Problem

`dime/README.md` has unresolved merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`). A repo with conflict markers cannot be pushed to GitHub cleanly and would be embarrassing as a public repo.

## Actions

- [x] Open `dime/README.md` and inspect the conflict markers
- [x] Resolve conflicts — reset local develop to origin/develop (remote had strictly more content, no unique local work)
- [x] Verify no other files in dime/ have conflict markers: `git diff --check`
- [x] No commit needed — reset aligned histories

## Notes

If [rewrite-dime-readme.md](rewrite-dime-readme.md) is in progress, coordinate — no point resolving conflicts in a file that's about to be fully rewritten.
