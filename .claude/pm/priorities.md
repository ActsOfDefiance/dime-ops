# Current Priorities

## Active Epic
epic-dime-core — the actual product

## Current Focus
- implement-pipeline (#17) — unblocked (api-layer #16 closed), critical path
- write-agent-prompts (#12) — unblocked, no dependencies, parallel track
- implement-astro-adapter (#19) — unblocked (adapters done)

## Next Up
- implement-agents (#18) — after pipeline (#17) + write-agent-prompts (#12)

## Blocked
- implement-agents (#18): waiting on pipeline (#17) + write-agent-prompts (#12)
- scaffold-dime-ui: unblocked (DECISION-002 settled — shadcn-svelte + Tailwind)
- set-up-acts-of-defiance-site: unblocked (DECISION-003 settled — Astro + Svelte 5)
- set-up-gcp-infra: waiting on DECISION-004

## Completed (epic-dime-core)
- configure-dime-project-deps (#20) — closed
- implement-db-schema (#14) — closed
- implement-adapters (#15) — closed
- implement-api-layer (#16) — closed

## Open Decisions
- DECISION-011 (integration test strategy, #11) — P2, resolve before heavy testing
- DECISION-007 (observability tooling, #13) — P2, resolve before production

## Stale Labels to Clean Up
- #16: still has `in-progress` label (should be removed, issue is closed)
- #17: still has `blocked` label (blocker #16 is now closed, should be removed)
