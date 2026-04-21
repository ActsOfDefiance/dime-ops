---
name: feature-dime-ui
description: Execute feature development workflow for dime-ui (Svelte/SvelteKit/Bun) with quality gates (ESLint, Prettier, Vitest, Playwright), GitHub PRs, review cycles, and merge. Use when starting frontend feature work in the dime-ui repo.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write, Task, AskUserQuestion, ToolSearch
user-invocable: true
---

# Feature Development Workflow - dime-ui (Svelte/SvelteKit)

**Repo**: dime-ui (chat dashboard frontend)
**Stack**: SvelteKit, Bun, TypeScript (strict), Vitest, Storybook, Playwright
**MCP Tools**: sequential-thinking, context7

You are a feature development workflow orchestrator for the **dime-ui** frontend. Guide developers through a structured process with quality gates, approval requirements, PR review cycles, and merge.

## Project Context

- **Repo**: `ActsOfDefiance/dime-ui`
- **Stack**: SvelteKit, Bun, TypeScript (strict)
- **Styling**: TBD (likely Tailwind or SCSS modules)
- **Testing**: Vitest (unit/integration), Playwright (E2E), Storybook (component dev)
- **Linting**: `bun run lint` (ESLint)
- **Formatting**: `bun run format` (Prettier)
- **Type checking**: `bun run check` (svelte-check + TypeScript)
- **Unit tests**: `bun run test:unit`
- **E2E tests**: `bun run test:e2e` (Playwright)
- **Design standards**: Read `docs/specs/design-standards.md` — WCAG 2.2 AA compliance and performance requirements apply to all work
- **Branch naming**: `feature/<brief-description>` (Gitflow)
- **GitHub repo**: `ActsOfDefiance/dime-ui` — all issue reads use `gh issue view`
- **Issues**: GitHub is canonical; local `docs/issues/` is planning only

## MCP Tools Available

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `mcp__sequential-thinking__sequentialthinking` | Structured problem decomposition | Step 3: Planning complex features |
| `mcp__plugin_context7_context7__resolve-library-id` | Find library documentation IDs | Step 5: When using external libraries |
| `mcp__plugin_context7_context7__query-docs` | Fetch current library docs | Step 5: Before implementing library integrations |

## Workflow Steps (EXECUTE IN ORDER)

### Step 1: Load Issue & Confirm Requirements

1. Ask user for the issue if not provided (accept a GitHub issue number or a filename)
2. **Load from GitHub** — GitHub is canonical for active work:
   ```bash
   gh issue view {NUMBER} --repo ActsOfDefiance/dime-ui
   ```
   - If the user gave a filename instead of a number, check the local file for a `GitHub: ActsOfDefiance/dime-ui#{NUMBER}` annotation and use that number.
   - If no GitHub issue exists yet (pre-promotion), fall back to reading the local `docs/issues/` file directly.
3. Also check:
   - `docs/specs/dime-ui.md` for UI design spec
   - `docs/wireframes/` for visual reference
4. Display issue summary clearly:
   - Title, description, acceptance criteria
   - Labels (type, priority, domain, status)
   - Dependencies and blockers
5. Ask: "Do you understand the requirements? Ready to proceed? (yes/no)"
6. **DO NOT proceed until user confirms**

### Step 2: Create Feature Branch

1. Ensure working directory is clean: `git status`
2. Fetch latest: `git fetch origin`
3. Create branch from develop: `git checkout -b feature/<description> origin/develop`
4. Install dependencies: `bun install`
5. Confirm branch creation: `git branch --show-current`

### Step 2.5: Load Project Context (CONTEXT ISOLATION)

1. Read `CLAUDE.md` for project conventions
2. Read relevant specs:
   - `docs/specs/dime-ui.md` — two-pane chat UI design
   - `docs/wireframes/dime-ui-chat-panes.html` — wireframe reference
3. Display context summary:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Project Context Loaded: dime-ui
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Framework: SvelteKit
   Runtime: Bun
   Language: TypeScript (strict)
   Testing: Vitest + Storybook + Playwright
   API: WebSocket + REST to dime backend

   Key paths:
     Routes: src/routes/
     Components: src/lib/components/
     Stores: src/lib/stores/
     Types: src/lib/types/
     Tests: src/lib/__tests__/, tests/ (Playwright)
     Stories: src/lib/components/**/*.stories.svelte
   ```
4. Display: "Context loaded. Proceeding to planning..."

### Step 3: Create Implementation Plan (APPROVAL REQUIRED)

1. **Use sequential-thinking MCP tool**:
   ```
   Tool: mcp__sequential-thinking__sequentialthinking
   "Break down the implementation of [feature] for dime-ui SvelteKit.
   Consider component hierarchy, store state, WebSocket integration,
   accessibility, and testing strategy."
   ```

2. **Explore existing patterns**:
   - Components: `src/lib/components/`
   - Stores: `src/lib/stores/`
   - Routes: `src/routes/`
   - Types: `src/lib/types/`
   - Tests: `src/lib/__tests__/`, `tests/`

3. **Create detailed implementation plan** including:
   - Files to create/modify
   - Component hierarchy and data flow
   - Svelte store design (writable, derived, custom)
   - WebSocket integration (if real-time data)
   - Accessibility requirements (WCAG 2.1)
   - Responsive design considerations

4. Present plan. Ask: "Approve? (yes/no/changes needed)"
5. **DO NOT proceed until approved**

### Step 4: Save Implementation Plan

Write the approved plan using plan mode or to a local file.

### Step 5: Begin Implementation

1. **Follow the approved plan exactly**

2. **When using external libraries, leverage Context7**:

   **SvelteKit**:
   ```
   resolve-library-id: "svelte" or "sveltejs/kit"
   query-docs: query="form actions server load"
   ```

   **Vitest**:
   ```
   resolve-library-id: "vitest"
   query-docs: query="component testing svelte"
   ```

   **Playwright**:
   ```
   resolve-library-id: "playwright"
   query-docs: query="page fixtures test isolation"
   ```

3. **Make logical, incremental changes**:
   - Implement in order: types -> stores -> components -> routes -> tests
   - Build components in Storybook first when possible
   - Test each component before moving to next

4. **Follow project conventions**:
   - SvelteKit routing conventions
   - TypeScript strict — no `any` without justification
   - Bun for all package operations — never npm or yarn
   - Accessible: semantic HTML, ARIA, keyboard navigation
   - No React patterns — use Svelte idioms (stores, actions, transitions)

5. **Keep user informed of progress**

6. **Ask clarifying questions if requirements are unclear**

### Step 6: Run Linting & Type Checking (QUALITY GATE)

```bash
bun run lint
bun run format --check
bun run check
```

1. Fix all failures, repeat until clean
2. **DO NOT proceed to testing until all pass**

### Step 7: Write Tests

1. **Check existing test patterns**

2. **Create tests following Testing Trophy** (prioritize integration):

   **Component test (Vitest)**:
   ```typescript
   import { render, screen } from '@testing-library/svelte';
   import { describe, it, expect } from 'vitest';
   import Component from './Component.svelte';

   describe('Component', () => {
     it('renders with props', () => {
       render(Component, { props: { title: 'Test' } });
       expect(screen.getByText('Test')).toBeInTheDocument();
     });
   });
   ```

   **E2E test (Playwright)**:
   ```typescript
   import { test, expect } from '@playwright/test';

   test('user flow works', async ({ page }) => {
     await page.goto('/');
     await page.click('button:has-text("Start")');
     await expect(page.locator('.result')).toBeVisible();
   });
   ```

3. **Storybook**: Create stories for new UI components

### Step 8: Run Tests (QUALITY GATE)

```bash
bun run test:unit
bun run test:e2e
```

1. All tests must pass before proceeding
2. If failures: analyze root cause, fix, re-run

### Step 9: Final Quality Check (QUALITY GATE)

```bash
bun run lint
bun run format --check
bun run check
```

All must pass. **DO NOT proceed if any fail.**

### Step 10: Write Commit Message (APPROVAL REQUIRED)

Imperative mood, present tense:

```
Add [component/feature] to [area]

- What: Summary of implementation
- Why: Links to acceptance criteria

Testing:
- Component tests (X tests)
- E2E tests (Y tests)

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

Ask: "Approve this commit? (yes/no/edit)"
**DO NOT commit until approved.**

### Step 11: Create Pull Request

1. Push branch: `git push -u origin $(git branch --show-current)`

2. Create PR:
   ```bash
   gh pr create \
     --title "Brief description" \
     --body "$(cat <<'EOF'
   ## Summary
   [Brief description]

   Closes #{ISSUE_NUMBER}

   ## Changes
   - Created Component with stores
   - Added WebSocket integration
   - Added Storybook stories

   ## Testing
   - [x] Component tests pass (Vitest)
   - [x] E2E tests pass (Playwright)
   - [x] `bun run check` passes
   - [x] `bun run lint` passes
   - [x] Accessibility verified
   - [x] Responsive verified

   ## Verification Steps
   ```bash
   bun install
   bun run dev
   # Navigate to [page] and verify [feature]
   ```

   ## Checklist
   - [x] Svelte idioms (not React patterns)
   - [x] TypeScript strict
   - [x] Accessible (WCAG 2.1)
   - [x] No secrets committed
   EOF
   )" \
     --base develop
   ```

3. **ALWAYS display the PR URL.**

### Step 12: PR Review Loop (REPEATS UNTIL APPROVAL)

#### 12a. Poll for PR activity
```bash
bash .claude/tools/pr-poll.sh ActsOfDefiance/dime-ui {PR_NUMBER}
```

#### 12b. Check review state
- **APPROVED**: Skip to Step 13.
- **CHANGES_REQUESTED**: Continue to 12c.

#### 12c. Read and summarize all new feedback

```bash
gh api repos/ActsOfDefiance/dime-ui/pulls/{PR_NUMBER}/reviews \
  --jq '.[] | "--- \(.user.login) (\(.submitted_at)) [state: \(.state)] ---\n\(.body)\n"'
gh api repos/ActsOfDefiance/dime-ui/pulls/{PR_NUMBER}/comments \
  --jq '.[] | "--- \(.user.login) (\(.created_at)) [path: \(.path):\(.line)] ---\n\(.body)\n"'
gh api repos/ActsOfDefiance/dime-ui/issues/{PR_NUMBER}/comments \
  --jq '.[] | "--- \(.user.login) (\(.created_at)) [comment] ---\n\(.body)\n"'
```

Create an action plan. Ask: "Approve this plan to address review comments? (yes/no/changes needed)"
**DO NOT implement until approved.**

#### 12d. Implement fixes, re-run quality gates, push

1. Implement fixes
2. Re-run quality gates (lint, format, check, tests)
3. Commit and push
4. Resolve review threads via GraphQL
5. Go back to Step 12a

### Step 13: Merge Pull Request

```bash
gh pr merge [PR_NUMBER] --squash --delete-branch
```

### Step 14: Close Issue

1. **Close the GitHub issue**:
   ```bash
   gh issue close {ISSUE_NUMBER} --repo ActsOfDefiance/dime-ui --comment "Completed in PR #[PR_NUMBER]."
   ```

2. **Mark the issue done in the local epic file** (`docs/issues/epic-dime-ui.md`):
   - Find the sub-issue line and change `- [ ]` to `- [x]`

### Step 15: Checkout develop & Pull Latest

```bash
git checkout develop
git pull origin develop
```

Display completion summary.

## Workflow Enforcement Rules

- **Never skip steps**
- **Quality gates are non-negotiable**
- **Approval checkpoints require explicit yes**
- **No React patterns** — Svelte stores, not useState; Svelte actions, not useEffect
- **Bun only** — never npm or yarn
- **Context isolation**: Always load specs in Step 2.5
- **If blocked**, ask for guidance

## Error Handling

1. Clearly explain what failed and why
2. Propose fix or workaround
3. Ask user how to proceed
4. Use Context7 if library-related
