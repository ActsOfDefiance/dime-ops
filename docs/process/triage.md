# Triage Process

How issues get labeled, prioritized, and assigned to epics.

## Label Taxonomy

See [github-label-taxonomy.md](../decisions/github-label-taxonomy.md) for the full label set. Every issue gets at least one **type** label and one **priority** label. Domain and status labels are added as applicable.

## Type Assignment

Determine from issue content:

| Signal | Label |
|---|---|
| Has sub-issues | `epic` |
| Describes new capability | `feature` |
| Something broken | `bug` |
| Cleanup/refactor | `maintenance` |
| Needs a decision made | `decision` |
| Secret/vulnerability | `security` |
| DX/CI/tooling | `tooling` |

## Priority Assignment

Applied in order — first match wins:

1. **Security issue** -> `P0-critical` (always, no discussion)
2. **Has dependents** (other issues are blocked by this one) -> `P1-high` (always)
3. **Everything else** -> suggest priority with reasoning, discuss before applying

## Domain Assignment

Inferred from issue content. An issue can have multiple domain labels:

| Content mentions | Label |
|---|---|
| Models, schema, migrations | `database` |
| FastAPI, endpoints, WebSocket | `api` |
| ADK, agents, prompts | `agent` |
| State machine, workers | `pipeline` |
| Astro, content emit | `publishing` |
| Svelte, frontend | `ui` |
| Visual, UX | `design` |
| GCP, deploy, CI | `infrastructure` |

## Status Labels

Applied based on current state:

| Condition | Label |
|---|---|
| Has unresolved blockers | `blocked` |
| Missing requirements | `needs-info` |
| Actively being worked | `in-progress` |
| Ready for review | `needs-review` |
