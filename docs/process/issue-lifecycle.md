# Issue Lifecycle

How issues flow from idea to completion.

## Stages

```
Idea -> Local Markdown -> Triage -> Promote to GitHub -> In Progress -> PR -> Merged -> Closed
```

### 1. Idea

An issue starts as an idea — a feature need, a bug report, a question. It may come from planning, conversation, or discovery during implementation.

### 2. Local Markdown

Write the issue as a markdown file in `docs/issues/`. Include:
- Type and priority
- Description and acceptance criteria
- Which epic it belongs to (add to the epic's sub-issue list)
- Dependencies and blockers

Local markdown is for planning. Issues can be incomplete, speculative, reorganized freely.

### 3. Triage

Use `/pm triage <issue>` to label and prioritize. The PM applies:
- Type label (auto)
- Domain labels (auto)
- Priority (auto for security/dependencies, suggests otherwise)
- Status labels if applicable (blocked, needs-info)

### 4. Promote to GitHub

Use `/pm promote` to review local issues ready for GitHub. An issue is ready when it has:
- Clear scope and acceptance criteria
- An assigned epic
- Understood dependencies

The PM creates the GitHub issue with labels and body from the local markdown. After promotion, GitHub is canonical.

### 5. In Progress

Work starts. The developer:
- Creates a feature branch
- Invokes the relevant feature skill (`/feature-dime`, `/feature-dime-ui`, `/feature-aod`)
- Follows the feature development workflow

### 6. PR

Work is submitted as a pull request against `develop`. The PR goes through review (human and/or automated).

### 7. Merged and Closed

PR is merged. GitHub issue is closed (automatically via PR or manually). The epic checklist is updated.

## Source of Truth

| Stage | Source of Truth |
|---|---|
| Planning | Local markdown (`docs/issues/`) |
| Active work | GitHub Issues |
| Completed | Git history + closed GitHub issues |

## Drift Detection

`/pm audit` compares local markdown against GitHub issues and flags:
- Issues promoted but modified locally without GitHub update
- GitHub issues with no local markdown counterpart
- Label mismatches between local metadata and GitHub labels
