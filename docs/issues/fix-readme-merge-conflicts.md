# Issue: Fix README merge conflicts

**Type:** housekeeping
**Priority:** high — must resolve before first push to GitHub
**Repo:** dime
**Epic:** epic-ops-setup

## Problem

`dime/README.md` has unresolved merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`). A repo with conflict markers cannot be pushed to GitHub cleanly and would be embarrassing as a public repo.

## Actions

- [ ] Open `dime/README.md` and inspect the conflict markers
- [ ] Resolve conflicts — if rewrite-dime-readme ticket is being worked concurrently, just accept that version wholesale
- [ ] Verify no other files in dime/ have conflict markers: `git diff --check`
- [ ] Stage and commit the resolution

## Notes

If [rewrite-dime-readme.md](rewrite-dime-readme.md) is in progress, coordinate — no point resolving conflicts in a file that's about to be fully rewritten.
