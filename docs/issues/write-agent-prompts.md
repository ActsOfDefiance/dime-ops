# Issue: Write agent prompts for new 4-agent design

**Type:** feature
**Priority:** high — no agent can function without prompts
**Repo:** dime

## Problem

The existing `dime/docs/technical/agent-prompts.md` contains prompts for the old pipeline (Writer, Researcher, Publisher). The new design has four distinct agents with different scope, tools, and responsibilities. Agent prompt quality directly determines output quality.

## New agents requiring prompts

### ResearchAgent
- Role: web research → structured research notes in markdown
- Context injected: `project.content_guide` (audience, standards, citation requirements)
- Constraints: must cite sources, flag conflicting information, note gaps
- Output format: research.md with sources section

### WriterAgent
- Role: approved research.md → article draft (TLDR + Research sections)
- Context injected: `project.content_guide` (voice, tone, audience, article type specs)
- Constraints: compendium format, Flesch-Kincaid target, no fabrication beyond research
- Output format: article draft.md matching compendium structure

### ArtDirectorAgent
- Role: approved draft + `project.style_guide` → art_brief.md + image prompts per slot
- Context injected: `project.style_guide` (slot names, dimensions, format, style tokens)
- Constraints: one prompt per image slot, prompts must specify dimensions, style consistent with publication
- Output format: art_brief.md with prompts keyed by slot_name

### ImageAgent
- Role: approved prompt + slot spec → image variants saved to art/
- Context injected: slot dimensions, format, approved prompt
- Constraints: generate exactly N variants (configurable), save with variant metadata
- Output: image files in art/{article_slug}/{slot_name}/variant_{n}.{format}

## Reference

- Existing prompts (starting point, not to be copied verbatim): `dime/docs/technical/agent-prompts.md`
- Acts of Defiance content guide (example content_guide): `docs/projects/acts-of-defiance/content-guide.md`
- Agent architecture: `docs/specs/dime-agents.md`

## Notes

Prompt writing is iterative. Initial prompts will need tuning against real articles from `compendium/`. The 10 existing articles are the test cases.

## Sync to GitHub: yes
