---
name: feature-dime
description: Execute feature development workflow for dime (Python/FastAPI/ADK) with quality gates (ruff, pyright, pytest 90% coverage), GitHub PRs, review cycles, and merge. Use when starting backend feature work in the dime repo.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write, Task, AskUserQuestion, ToolSearch
user-invocable: true
---

# Feature Development Workflow - dime (Python)

**Repo**: dime (Python backend)
**Stack**: Python 3.13, uv, FastAPI, Google ADK, SQLAlchemy, Alembic
**Quality**: ruff, pyright, pytest (90% coverage minimum)
**MCP Tools**: sequential-thinking, context7

You are a feature development workflow orchestrator for the **dime** backend. Guide developers through a structured process with quality gates, approval requirements, PR review cycles, and merge.

## Project Context

- **Repo**: `ActsOfDefiance/dime`
- **Stack**: Python 3.13, FastAPI, Google ADK (agents), SQLAlchemy + Alembic, PostgreSQL, Redis
- **Linting**: `uv run ruff check .`
- **Formatting**: `uv run ruff format --check .`
- **Type checking**: `uv run pyright`
- **Testing**: `uv run pytest --cov --cov-fail-under=90`
- **Coverage Requirement**: 90% minimum
- **Branch naming**: `feature/<brief-description>` (Gitflow)
- **GitHub repo**: `ActsOfDefiance/dime` — all issue reads use `gh issue view`
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
   gh issue view {NUMBER} --repo ActsOfDefiance/dime
   ```
   - If the user gave a filename instead of a number, check the local file for a `GitHub: ActsOfDefiance/dime#{NUMBER}` annotation and use that number.
   - If no GitHub issue exists yet (pre-promotion), fall back to reading the local `docs/issues/` file directly.
3. Display issue summary clearly:
   - Title, description, acceptance criteria
   - Labels (type, priority, domain, status)
   - Dependencies and blockers
   - Which epic it belongs to
4. Ask: "Do you understand the requirements? Ready to proceed? (yes/no)"
5. **DO NOT proceed until user confirms**

### Step 2: Create Feature Branch

1. Ensure working directory is clean: `git status`
2. Fetch latest: `git fetch origin`
3. Create branch from develop: `git checkout -b feature/<description> origin/develop`
4. Confirm branch creation: `git branch --show-current`
5. Display: "Branch created. Loading project context..."

### Step 2.5: Load Project Context (CONTEXT ISOLATION)

**Critical step to establish conventions for this feature.**

1. Read `CLAUDE.md` for project conventions
2. Read `docs/specs/` files relevant to the feature:
   - `dime-architecture.md` — 4-layer architecture
   - `dime-pipeline.md` — 11-state pipeline
   - `dime-data-model.md` — PostgreSQL schema
   - `dime-agents.md` — ADK agent design
3. Display context summary:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Project Context Loaded: dime
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Language: Python 3.13
   Framework: FastAPI + Google ADK
   Tooling: uv, ruff, pyright, pytest
   Database: PostgreSQL + SQLAlchemy + Alembic
   Broker: Redis (pluggable via BrokerAdapter)

   Key paths:
     Package: dime/
     Agents: agents/ (ADK discovery) + dime/agents/
     Tests: tests/
     Specs: docs/specs/ (symlinked from dime-ops)
   ```
4. Display: "Context loaded. Proceeding to planning..."

### Step 3: Create Implementation Plan (APPROVAL REQUIRED)

1. **Use sequential-thinking MCP tool** for structured problem decomposition:
   ```
   Tool: mcp__sequential-thinking__sequentialthinking
   Example prompt:
   "Break down the implementation of [feature name] for dime.
   Consider the 4-layer architecture (adapters, pipeline, API, agents),
   database models, FastAPI endpoints, and testing strategy."
   ```

2. **Explore existing patterns** in the codebase:
   - Adapter interfaces: `dime/adapters/`
   - Pipeline states: `dime/pipeline/`
   - API routes: `dime/api/`
   - Agent structure: `agents/dime_agent/`, `dime/agents/`
   - Test patterns: `tests/`

3. **Create detailed implementation plan** including:
   - Files to create/modify with rationale
   - Architecture decisions (which layer? which adapter?)
   - API changes (new FastAPI endpoints, request/response schemas)
   - Database changes (new models, migrations, indexes)
   - Pipeline state transitions affected
   - Agent modifications (if applicable)
   - Dependencies and blockers

4. Present plan to developer
5. Ask: "Do you approve this implementation plan? (yes/no/changes needed)"
6. **DO NOT proceed to implementation until plan is approved**
7. If rejected, iterate on plan with user feedback

### Step 4: Save Implementation Plan

1. Write the approved plan using the plan mode or to a local file
2. Display: "Implementation plan saved. Proceeding to implementation..."

### Step 5: Begin Implementation

1. **Follow the approved plan exactly** — do not deviate without approval

2. **When using external libraries, leverage Context7 MCP tools**:

   **FastAPI**:
   ```
   resolve-library-id: "fastapi"
   query-docs: libraryId="/fastapi/fastapi" query="websocket endpoints"
   ```

   **SQLAlchemy**:
   ```
   resolve-library-id: "sqlalchemy"
   query-docs: libraryId="/sqlalchemy/sqlalchemy" query="async session"
   ```

   **Google ADK**:
   ```
   resolve-library-id: "google adk"
   query-docs: query="LlmAgent tool implementation"
   ```

3. **Make logical, incremental changes**:
   - Implement in order: models/migrations -> adapters -> API endpoints -> pipeline logic -> agents
   - Run migrations after creating them
   - Test each component before moving to next

4. **Follow project conventions**:
   - Always use `uv run` — never call `python` directly
   - Imports in file header only, never inline
   - All files end with a single newline
   - Pydantic for data validation and settings
   - Start simple — do not overengineer
   - Secrets in `.envrc` only — never `.env`, never committed

5. **Keep user informed of progress**:
   - "Created model at dime/models/resource.py"
   - "Generated migration via Alembic"
   - "Implemented endpoint at dime/api/routes/resource.py"

6. **Ask clarifying questions if requirements are unclear**

### Step 6: Run Linters, Formatting & Type Checking (QUALITY GATE)

Execute in order:
```bash
uv run ruff check .
uv run ruff format --check .
uv run pyright
```

1. Display results clearly for each tool
2. If any failures:
   - **Ruff check**: Fix violations, re-run
   - **Ruff format**: Run `uv run ruff format .`, re-run check
   - **Pyright**: Fix type errors, re-run
   - Repeat until all pass
3. **DO NOT proceed to testing until all pass**
4. Display: "All quality checks passed. Proceeding to testing..."

### Step 7: Write Tests

1. **Check existing test patterns** in `tests/`:
   - Fixtures: `tests/conftest.py`
   - Model tests, API tests, agent tests

2. **Create tests for new functionality**:

   **Model tests**:
   ```python
   import pytest
   from dime.models import Resource

   @pytest.mark.asyncio
   async def test_create_resource(db_session):
       resource = Resource(name="test")
       db_session.add(resource)
       await db_session.commit()
       assert resource.id is not None
   ```

   **API tests**:
   ```python
   import pytest
   from httpx import AsyncClient

   @pytest.mark.asyncio
   async def test_create_resource_endpoint(client: AsyncClient):
       response = await client.post("/api/v1/resources", json={"name": "test"})
       assert response.status_code == 201
   ```

3. **Target 90%+ coverage for new code**:
   - Test happy paths
   - Test error cases (validation, not found, etc.)
   - Test edge cases from implementation plan

### Step 8: Run Tests with Coverage (QUALITY GATE)

```bash
uv run pytest -v --cov --cov-fail-under=90 --cov-report=term-missing
```

1. **Coverage must be at least 90%**
2. If failures or coverage below threshold:
   - **Analyze failure root cause** (don't just retry)
   - **Fix implementation** or **add missing tests**
   - **Re-run** until all pass AND coverage >= 90%
3. **ALL tests must pass with 90% coverage before proceeding**
4. Display: "All tests passed with 90%+ coverage. Running final quality checks..."

### Step 9: Final Quality Check (QUALITY GATE)

Run again to catch any changes from test fixes:

```bash
uv run ruff check .
uv run ruff format --check .
uv run pyright
```

1. All must pass
2. **DO NOT proceed if any fail** — fix and re-run
3. Display: "Final quality checks passed. Preparing commit..."

### Step 10: Write Commit Message (APPROVAL REQUIRED)

1. **Summarize all changes made** during implementation
2. **Generate commit message** following project conventions (imperative mood, present tense):

```
Add [feature] to [layer]

- What: Summary of implementation
- Why: Links to acceptance criteria from issue

Acceptance criteria addressed:
- [ ] Criterion 1
- [ ] Criterion 2

Testing:
- Unit/integration tests added (X tests)
- Coverage: XX% (target: 90%+)

Database changes:
- Migration: alembic/versions/XXXX_description.py
- New model: Resource

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

3. Present to user: "Proposed commit message: [show message]"
4. Ask: "Approve this commit? (yes/no/edit)"
5. **DO NOT commit until approved**
6. If approved:
   ```bash
   git add [changed files]   # prefer specific files over git add -A
   git commit -m "[approved message]"
   ```

### Step 11: Create Pull Request

1. **Push branch to remote**:
   ```bash
   git push -u origin $(git branch --show-current)
   ```

2. **Create PR using GitHub CLI**:
   ```bash
   gh pr create \
     --title "Brief description" \
     --body "$(cat <<'EOF'
   ## Summary
   [Brief description of changes]

   Closes #{ISSUE_NUMBER}

   ## Changes
   - Added model for resources
   - Created API endpoints
   - Implemented adapter logic

   ## Testing
   - [x] Unit tests pass
   - [x] Integration tests pass
   - [x] Coverage >= 90%
   - [x] All quality checks pass (ruff, pyright)

   ## Database Changes
   - Migration: alembic/versions/XXXX_description.py

   ## Verification Steps
   ```bash
   uv sync
   uv run alembic upgrade head
   uv run pytest
   ```

   ## Checklist
   - [x] Code follows dime conventions (CLAUDE.md)
   - [x] Specs consulted (docs/specs/)
   - [x] No secrets committed
   - [x] Migration tested
   EOF
   )" \
     --base develop
   ```

3. **ALWAYS display the PR URL**:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Step 11: Complete
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   - Branch pushed to origin
   - PR opened: [FULL GITHUB PR URL]

   Proceeding to PR review cycle...
   ```

### Step 12: PR Review Loop (REPEATS UNTIL APPROVAL)

#### 12a. Poll for PR activity

Run a background poll:
```bash
bash .claude/tools/pr-poll.sh ActsOfDefiance/dime {PR_NUMBER}
```

#### 12b. Check for approval or changes requested

- **APPROVED**: Skip to Step 13 (merge).
- **CHANGES_REQUESTED** or new feedback: Continue to 12c.
- **DISMISSED** or no actionable feedback: Resume polling (back to 12a).

#### 12c. Read and summarize all new feedback

```bash
gh api repos/ActsOfDefiance/dime/pulls/{PR_NUMBER}/reviews \
  --jq '.[] | "--- \(.user.login) (\(.submitted_at)) [state: \(.state)] ---\n\(.body)\n"'
gh api repos/ActsOfDefiance/dime/pulls/{PR_NUMBER}/comments \
  --jq '.[] | "--- \(.user.login) (\(.created_at)) [path: \(.path):\(.line)] ---\n\(.body)\n"'
gh api repos/ActsOfDefiance/dime/issues/{PR_NUMBER}/comments \
  --jq '.[] | "--- \(.user.login) (\(.created_at)) [comment] ---\n\(.body)\n"'
```

Create an action plan. Ask: "Approve this plan to address review comments? (yes/no/changes needed)"
**DO NOT implement until approved.**

#### 12d. Implement fixes, re-run quality gates, push

1. Implement fixes
2. Re-run quality gates (ruff, pyright, pytest 90%)
3. Commit and push
4. Resolve review threads via GraphQL
5. Go back to Step 12a

### Step 13: Merge Pull Request

1. **Merge the PR**:
   ```bash
   gh pr merge [PR_NUMBER] --squash --delete-branch
   ```

2. Display:
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Step 13: Complete
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   - PR merged (squash)
   - Remote branch deleted
   ```

### Step 14: Checkout develop & Pull Latest

```bash
git checkout develop
git pull origin develop
```

Display:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Feature workflow complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Checked out: develop
- Pulled latest from origin
```

## Workflow Enforcement Rules

- **Never skip steps** — each builds on the previous
- **Quality gates are non-negotiable** — ruff/pyright/pytest must pass
- **Coverage threshold**: 90% minimum, no exceptions
- **Approval checkpoints require explicit yes** — don't assume approval
- **Show progress clearly**: "Step X: [StepName]"
- **Context isolation**: Always load specs in Step 2.5
- **Check local docs first**: `docs/issues/` and `docs/specs/`
- **If blocked**, ask for guidance — don't make assumptions

## Error Handling

If any step fails:
1. **Clearly explain what failed and why** (root cause analysis)
2. **Propose fix or workaround**
3. **Ask user how to proceed**
4. **Do not silently continue or retry without investigation**
5. **Use Context7 if library-related** — fetch official documentation
