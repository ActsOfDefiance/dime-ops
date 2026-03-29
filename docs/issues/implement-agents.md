# Issue: Implement ADK agents

**Type:** feature
**Priority:** high
**Repo:** dime
**Epic:** epic-dime-core
**Blocked by:** implement-adapters, implement-pipeline, write-agent-prompts

## Agents to implement

All agents are ADK `LlmAgent` except `PublisherAgent` (no LLM). See `docs/specs/dime-agents.md` for full spec.

### ResearchAgent
**Input:** article title, topic brief, content_guide
**Output:** research notes (markdown), source list
**Tools:** web search (Grounding API or Tavily), source validator, note writer

### WriterAgent
**Input:** research notes, content_guide (audience, voice, standards, article_type config)
**Output:** article draft (markdown), word count, citation list
**Tools:** draft writer, citation formatter, word counter
**Note:** content_guide is injected from `GET /projects/{id}/content-guide` — not hardcoded

### ArtDirectorAgent
**Input:** article draft, content_guide (image standards), project style_guide
**Output:** art brief (list of image_slot definitions: role, dimensions, prompt, alt text)
**Tools:** image slot creator, brief formatter

### ImageAgent
**Input:** art brief (one slot at a time), project style_guide
**Output:** generated image (GCS URI), image metadata
**Tools:** Imagen 3 API caller, GCS uploader (via FileSystemAdapter)
**Note:** runs once per image slot, dispatched in parallel

### PublisherAgent (no LLM)
**Input:** article (final state), image variants
**Output:** publish signal
**Actions:** call PublishingAdapter.emit(), call PublishingAdapter.signal(), update publish_event in DB via API
**Note:** deterministic — no LLM, just orchestration

## content_guide injection pattern

All LLM agents must:
1. Fetch `content_guide` from API at task start (not at worker start — guide may change between articles)
2. Inject into system prompt context
3. Respect `article_types` config for the current article type (word count, structure)

## Implementation structure

```
dime/
  agents/
    __init__.py
    research.py
    writer.py
    art_director.py
    image.py
    publisher.py
    tools/
      content_guide_tools.py   ← fetch + format content_guide for agent context
      search_tools.py
      image_tools.py
      filesystem_tools.py
```

## Acceptance criteria

- [ ] Each agent can be instantiated and run in isolation with a test task
- [ ] content_guide is fetched from API (not hardcoded) and present in agent context
- [ ] Agent failures surface as structured errors (not raw exceptions) — worker catches and marks article `failed`
- [ ] ImageAgent runs for each slot independently (parallelizable)
- [ ] PublisherAgent emits valid Hugo content (validated by running `hugo --dry-run`)
- [ ] `pyright` no errors
- [ ] `pytest tests/test_agents.py` — mocked LLM responses for deterministic unit tests (LLM is mocked here, not the broker/filesystem)
