# GitHub Label Taxonomy

Standardized across all repos: dime-ops, dime, dime-ui, acts-of-defiance, compendium.

## Type

| Label | Color | Description |
|---|---|---|
| `epic` | #1D76DB | Groups related issues |
| `feature` | #0075ca | New functionality |
| `bug` | #d73a4a | Something broken |
| `maintenance` | #5319e7 | Refactoring, cleanup, housekeeping |
| `decision` | #7057ff | Architectural or tooling decision |
| `security` | #b60205 | Security-related |
| `tooling` | #006b75 | Developer experience, CI, skills |

## Priority

| Label | Color | Description |
|---|---|---|
| `P0-critical` | #b60205 | Blocking, fix immediately |
| `P1-high` | #d93f0b | Must complete this sprint |
| `P2-medium` | #fbca04 | Should do soon |
| `P3-low` | #0e8a16 | Future consideration |

## Domain

| Label | Color | Description |
|---|---|---|
| `agent` | #1d8a6e | ADK agents, prompts |
| `api` | #0e6e5c | FastAPI endpoints, WebSocket |
| `database` | #1a7f5a | Schema, migrations, queries |
| `pipeline` | #2b8a6e | State machine, worker dispatch |
| `publishing` | #3a9a7e | Hugo/Astro adapter, content emit |
| `ui` | #4aaa8e | Svelte frontend |
| `design` | #5abba0 | Visual design, UX |
| `infrastructure` | #0d5e4e | GCP, deploy, CI/CD |

## Status

| Label | Color | Description |
|---|---|---|
| `blocked` | #e4e669 | Waiting on dependency |
| `needs-info` | #d876e3 | Requires clarification |
| `in-progress` | #ededed | Actively being worked |
| `needs-review` | #c2e0c6 | Ready for review |

## Usage guidelines

- Every issue gets at least one **type** label and one **priority** label
- Add **domain** labels as applicable (an issue can span multiple domains)
- **Status** labels are optional and reflect current workflow state
- Epics get the `epic` type label; child issues reference the epic in their body
