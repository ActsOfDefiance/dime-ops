---
name: feature-aod
description: Execute feature development workflow for acts-of-defiance (Hugo static site) with content publishing, theme development, and publishing adapter integration. Use when working on the publication site.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write, Task, AskUserQuestion, ToolSearch
user-invocable: true
---

# Feature Development Workflow - acts-of-defiance (Hugo)

**Repo**: acts-of-defiance (the publication)
**Stack**: Hugo, Markdown, HTML/CSS/JS templates
**Note**: Evaluating migration to Astro (DECISION-003) — check current state before assuming Hugo

You are a feature development workflow orchestrator for the **acts-of-defiance** publication site. Guide developers through structured work on the static site — theme development, content templates, publishing adapter integration, and deployment.

## Project Context

- **Repo**: `ActsOfDefiance/acts-of-defiance`
- **Stack**: Hugo (currently), possibly Astro (pending DECISION-003)
- **Content source**: `compendium/` repo (Markdown articles, GPLv3)
- **Image source**: GCS (images are artifacts, not in git)
- **Publishing**: dime's PublishingAdapter signals article readiness
- **Branch naming**: `feature/<brief-description>` (Gitflow)
- **Issues**: local markdown in `docs/issues/` (symlinked from dime-ops)

## Hugo Commands

```bash
# Development server
hugo server -D

# Build
hugo

# New content
hugo new content posts/article-slug.md
```

## Workflow Steps (EXECUTE IN ORDER)

### Step 1: Load Issue & Confirm Requirements

1. Ask user for the issue if not provided
2. **Check local issue files** at `docs/issues/`
3. For content/theme work, also check:
   - `docs/specs/dime-overview.md` — publishing flow
   - `docs/projects/acts-of-defiance/content-guide.md` — tone, audience, style
4. Display issue summary
5. Ask: "Ready to proceed? (yes/no)"
6. **DO NOT proceed until user confirms**

### Step 2: Create Feature Branch

1. Ensure working directory is clean: `git status`
2. Fetch latest: `git fetch origin`
3. Create branch: `git checkout -b feature/<description> origin/develop`
4. Confirm: `git branch --show-current`

### Step 2.5: Load Project Context

1. Read `CLAUDE.md` for site conventions
2. Understand the Hugo directory structure:
   ```
   acts-of-defiance/
     archetypes/          # Content templates
     assets/              # Processed assets (SCSS, JS)
     content/             # Site content (posts, pages)
     data/                # Data files
     layouts/             # HTML templates
     static/              # Static assets (images, fonts)
     themes/              # Hugo themes
     hugo.toml            # Site configuration
   ```
3. Display: "Context loaded. Proceeding to planning..."

### Step 3: Create Implementation Plan (APPROVAL REQUIRED)

1. **Determine the type of work**:
   - **Theme/layout**: Changes to `layouts/`, `assets/`, `themes/`
   - **Content template**: Changes to `archetypes/`, frontmatter schema
   - **Publishing integration**: How dime's PublishingAdapter signals content
   - **Configuration**: `hugo.toml`, taxonomies, menus

2. **Create detailed plan** including:
   - Files to create/modify
   - Template hierarchy (base → section → single)
   - Frontmatter fields needed
   - Asset pipeline changes
   - How this integrates with dime's publishing adapter

3. Present plan. Ask: "Approve? (yes/no/changes needed)"
4. **DO NOT proceed until approved**

### Step 4: Save Implementation Plan

Write the approved plan using plan mode or to a local file.

### Step 5: Begin Implementation

1. **Follow the approved plan exactly**

2. **Hugo-specific guidelines**:
   - Use Hugo's template lookup order
   - Prefer `hugo.toml` over `config.yaml` or `config.json`
   - Use Hugo Pipes for asset processing
   - Use shortcodes for reusable content patterns
   - Respect content organization (sections, taxonomies)
   - Frontmatter: TOML preferred (matches hugo.toml)

3. **Content guidelines** (from content-guide.md):
   - Target audience: liberal adults 20-40
   - Tone: informed, accessible, not academic
   - All articles must have proper frontmatter

4. **Keep user informed of progress**

### Step 6: Build & Verify (QUALITY GATE)

```bash
# Build the site — Hugo reports errors here
hugo

# Run dev server and verify visually
hugo server -D
```

1. Fix all build errors
2. **DO NOT proceed if build fails**
3. Display: "Build succeeded. Verify visually at http://localhost:1313"

### Step 7: Visual Verification (APPROVAL REQUIRED)

1. Ask user to verify the changes visually at `http://localhost:1313`
2. Ask: "Does the site look correct? (yes/no/changes needed)"
3. **DO NOT proceed until approved**

### Step 8: Write Commit Message (APPROVAL REQUIRED)

Imperative mood, present tense:

```
Add [feature] to site

- What: Summary of changes
- Why: Purpose/goal

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

Ask: "Approve this commit? (yes/no/edit)"
**DO NOT commit until approved.**

### Step 9: Create Pull Request

1. Push: `git push -u origin $(git branch --show-current)`
2. Create PR:
   ```bash
   gh pr create \
     --title "Brief description" \
     --body "$(cat <<'EOF'
   ## Summary
   [Brief description]

   ## Changes
   - Modified layout templates
   - Updated frontmatter schema
   - Added new shortcode

   ## Verification
   ```bash
   hugo server -D
   # Navigate to [page] and verify [feature]
   ```

   ## Checklist
   - [x] `hugo` builds without errors
   - [x] Visually verified at localhost:1313
   - [x] Responsive design verified
   - [x] Content guide followed (if content changes)
   - [x] No secrets committed
   EOF
   )" \
     --base develop
   ```

3. **ALWAYS display the PR URL.**

### Step 10: PR Review Loop

#### 10a. Poll for activity
```bash
bash .claude/tools/pr-poll.sh ActsOfDefiance/acts-of-defiance {PR_NUMBER}
```

#### 10b. Check for approval or changes requested

- **APPROVED**: Skip to Step 11 (merge).
- **CHANGES_REQUESTED** or new feedback: Continue to 10c.
- **DISMISSED** or no actionable feedback: Resume polling (back to 10a).

#### 10c. Read and summarize all new feedback

```bash
gh api repos/ActsOfDefiance/acts-of-defiance/pulls/{PR_NUMBER}/reviews \
  --jq '.[] | "--- \(.user.login) (\(.submitted_at)) [state: \(.state)] ---\n\(.body)\n"'
gh api repos/ActsOfDefiance/acts-of-defiance/pulls/{PR_NUMBER}/comments \
  --jq '.[] | "--- \(.user.login) (\(.created_at)) [path: \(.path):\(.line)] ---\n\(.body)\n"'
gh api repos/ActsOfDefiance/acts-of-defiance/issues/{PR_NUMBER}/comments \
  --jq '.[] | "--- \(.user.login) (\(.created_at)) [comment] ---\n\(.body)\n"'
```

Create an action plan. Ask: "Approve this plan to address review comments? (yes/no/changes needed)"
**DO NOT implement until approved.**

#### 10d. Implement fixes, rebuild, push

1. Implement fixes
2. Re-run `hugo` build — must succeed
3. Commit and push
4. Resolve review threads via GraphQL
5. Go back to Step 10a

### Step 11: Merge & Checkout develop

```bash
gh pr merge [PR_NUMBER] --squash --delete-branch
git checkout develop
git pull origin develop
```

Display completion summary.

## Workflow Enforcement Rules

- **Never skip steps**
- **Build must succeed before PR**
- **Visual verification required** — Hugo sites need human eyes
- **Approval checkpoints require explicit yes**
- **Content guide compliance** for any content changes
- **If blocked**, ask for guidance

## Publishing Adapter Integration

The dime pipeline's PublishingAdapter signals article readiness:
1. dime emits markdown + frontmatter to `compendium/`
2. PublishingAdapter writes a signal file
3. acts-of-defiance picks up content (manual or automated)
4. Images are downloaded from GCS, not stored in git

When working on publishing integration, consult:
- `docs/specs/dime-pipeline.md` — publish state
- `docs/specs/dime-architecture.md` — adapter pattern
