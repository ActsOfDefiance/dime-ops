# PM Agent — Design Spec

## Overview

A Claude Code skill (`/pm`) that acts as a project manager for the dime ecosystem. It triages issues, manages priorities, tracks epics, maintains process docs, and facilitates decisions. It does not implement features, create PRs, or dispatch implementation skills.

**Architecture:** Single skill at `.claude/commands/pm.md` with internal knowledge in `.claude/pm/`. Migration path: when the skill outgrows a single file, the body moves to `.claude/agents/pm.md` and the skill becomes a thin launcher.

## Scope

**Does:**
- Triage issues (label, prioritize, assign to epics)
- Track epic progress and blocker status
- Generate roadmaps and status reports
- Recommend what to work on next with reasoning
- Promote firm local issues to GitHub
- Audit GitHub issues against local markdown for drift
- Maintain `docs/process/` as living documentation
- Facilitate architectural decisions (does not decide unilaterally)
- Learn from corrections and update its playbook
- Spawn background agents for expensive operations (multi-repo audits, roadmap generation)

**Does not:**
- Dispatch implementation skills (`feature-dime`, etc.)
- Create PRs or branches
- Run code, tests, or quality gates
- Assign issues to individuals
- Close issues (happens via PR merge)

## File Structure

```
.claude/
  commands/
    pm.md                  <- the skill (entry point, routing, all capabilities)
  pm/
    playbook.md            <- learned decision patterns (agent-internal)
    priorities.md          <- current focus and rationale (agent-internal)
docs/
  process/
    triage.md              <- how issues get triaged (public)
    sprint-planning.md     <- how work gets sequenced (public)
    definition-of-done.md  <- what "done" means (public)
    decision-making.md     <- how decisions get made (public)
    issue-lifecycle.md     <- local -> GitHub -> done (public)
  decisions/
    github-label-taxonomy.md  <- label definitions (already exists)
```

## Entry Point and Routing

The skill accepts natural language or explicit sub-commands. On invocation it:

1. Reads `.claude/pm/playbook.md` and `.claude/pm/priorities.md`
2. Reads `docs/decisions/github-label-taxonomy.md`
3. Parses intent and routes

### Sub-Commands

| Command | Description |
|---|---|
| `/pm` | Natural language — PM figures out what you need |
| `/pm help` | Show available commands and descriptions |
| `/pm triage <issue>` | Label, prioritize, and slot an issue into an epic |
| `/pm triage-epic <epic>` | Triage all issues in a local epic file |
| `/pm status` | Current state: in progress, blocked, next up |
| `/pm roadmap` | Generate roadmap from epics, blockers, priorities |
| `/pm next` | Recommend what to work on next with reasoning |
| `/pm promote` | Review local issues ready to push to GitHub |
| `/pm audit` | Audit GitHub issues against local markdown for drift |
| `/pm retro` | Summarize recent completed work from git/issues |
| `/pm learned` | Show what the PM has learned (dump playbook) |

### Natural Language Routing

The PM infers intent from the user's message:

- "what should I work on?" -> `next`
- "triage the db schema issue" -> `triage`
- "where are we on dime core?" -> `status`
- "push the adapter issues to github" -> `promote`
- "what have we finished this week?" -> `retro`
- "show me the roadmap" -> `roadmap`

When intent is ambiguous, the PM asks for clarification rather than guessing.

## Triage Logic

When triaging an issue, the PM applies labels in this order:

### 1. Type (required, auto-applied)

- Has sub-issues -> `epic`
- Describes new capability -> `feature`
- Something broken -> `bug`
- Cleanup/refactor -> `maintenance`
- Needs a decision made -> `decision`
- Secret/vulnerability -> `security`
- DX/CI/tooling -> `tooling`

### 2. Priority (required, rules-based)

Applied in order:
1. Security issue -> `P0-critical` (auto)
2. Has dependents (other issues blocked by this) -> `P1-high` (auto)
3. Otherwise -> PM suggests priority with reasoning, asks for approval

### 3. Domain (optional, auto-applied, can be multiple)

- Mentions models/schema/migrations -> `database`
- Mentions FastAPI/endpoints/WebSocket -> `api`
- Mentions ADK/agents/prompts -> `agent`
- Mentions state machine/workers -> `pipeline`
- Mentions Astro/content emit -> `publishing`
- Mentions Svelte/frontend -> `ui`
- Mentions visual/UX -> `design`
- Mentions GCP/deploy/CI -> `infrastructure`

### 4. Status (optional, auto-applied)

- Has unresolved blockers -> `blocked`
- Missing requirements -> `needs-info`

## Issue Lifecycle

### Source of Truth

- **Local markdown** (`docs/issues/`): planning, speculation, reorganization
- **GitHub Issues**: canonical active work

### Promotion Flow

`/pm promote` reviews local issues and identifies those ready for GitHub:
- Has clear scope and acceptance criteria
- Assigned to an epic
- Dependencies are understood

The PM presents a batch with proposed labels. User approves, adjusts, or skips individual issues. When promoting an entire epic, `/pm triage-epic` triages all sub-issues and offers to promote the batch.

### After Promotion

- GitHub is canonical for status, comments, closure
- Local markdown remains as planning reference
- `/pm audit` detects drift between local and GitHub

## Autonomy Model

The PM starts consultative and grows autonomous as it learns.

### Launch Autonomy

| Action | Behavior |
|---|---|
| Apply labels (type, domain) | Auto |
| Apply priority (security) | Auto — P0-critical |
| Apply priority (has dependents) | Auto — P1-high |
| Apply priority (other) | Suggest with reasoning, ask |
| Create GitHub issue | Ask, unless user specifies an epic or batch |
| Sequence work in epic | Only on priorities/dependencies, not on order within equal items |
| Update process docs | Ask (so user can learn how the agent thinks) |
| Update playbook | Auto |

### Growing Autonomy

As the playbook accumulates patterns, the PM can act on more decisions without asking. The transition is organic — when a pattern has been confirmed multiple times, the PM applies it directly and mentions what it did rather than asking permission.

## Self-Learning

### Playbook (`.claude/pm/playbook.md`)

Updated automatically when the user corrects the PM. Uses "we" consensus language throughout — never individual names.

Structure:
```markdown
# PM Playbook

## Priority Patterns
- Security issues are always P0-critical
- Issues with dependents are P1-high
- We prefer tackling issues that unblock the most downstream work first

## Triage Patterns
- [grows over time as PM is corrected]

## Process Patterns
- [accumulated from corrections and approvals]
```

When corrected, the PM:
1. Applies the correction
2. Writes the pattern to playbook.md with reasoning
3. Consults the playbook on future similar decisions

### Priorities (`.claude/pm/priorities.md`)

Updated when work completes, priorities shift, or focus is redirected:
```markdown
# Current Priorities

## Active Epic
[current epic being worked]

## Current Focus
[specific blocker or task]

## Next Up
[what follows after current focus]
```

### Promoting to Process Docs

When the PM notices a playbook pattern is general (not preference), it proposes updating the relevant `docs/process/` file. Asks first.

## Process Docs — Initial Content

### `docs/process/triage.md`
- Label taxonomy reference (links to `github-label-taxonomy.md`)
- Priority rules: security -> P0, has dependents -> P1, otherwise discuss
- Domain label inference rules
- When to apply status labels

### `docs/process/sprint-planning.md`
- Work sequenced by epic order, then dependency graph within each epic
- Unblocked items with the most dependents get priority
- We prefer resolving blocking decisions before starting dependent work

### `docs/process/definition-of-done.md`
- Feature: tests pass, quality gates clean, PR merged
- Bug: root cause identified, fix verified, regression test added
- Decision: recorded in `settled-decisions.md` with rationale
- Epic: all sub-issues done, DoD checklist in epic file passes

### `docs/process/decision-making.md`
- Decisions start in `open-decisions.md` with context and options
- Brainstorming skill used for new feature decisions
- Once decided, moved to `settled-decisions.md` with rationale
- PM facilitates but does not decide unilaterally

### `docs/process/issue-lifecycle.md`
- Idea -> local markdown (`docs/issues/`) -> triage -> promote to GitHub -> in progress -> PR -> merged -> closed
- Local markdown is planning; GitHub is canonical
- Epics track sub-issue completion via checklists

## Repos

The PM operates across all repos in the org:

| Repo | What PM manages |
|---|---|
| `dime-ops` | Epics, process docs, cross-repo coordination, infrastructure issues |
| `dime` | Backend feature/bug issues |
| `dime-ui` | Frontend feature/bug issues (when repo exists) |
| `acts-of-defiance` | Site/publishing issues |
| `compendium` | Content issues |

## Background Agents

The PM can spawn background agents for expensive operations:
- **Multi-repo audit**: check all 4 repos for label consistency, drift, stale issues
- **Roadmap generation**: read all epics, resolve dependency graph, generate current state
- **Retro**: scan git logs across repos for recent completions

These run asynchronously and report results back.

## Future: Migration to Agent (Approach B)

When the skill outgrows a single file:
1. Move skill body to `.claude/agents/pm.md`
2. `.claude/commands/pm.md` becomes a thin launcher that parses args and invokes the agent
3. Sub-commands, playbook, process docs, and taxonomy stay unchanged
4. Agent gains ability to be dispatched by other agents/skills in the future
