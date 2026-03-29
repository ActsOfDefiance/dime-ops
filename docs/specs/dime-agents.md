# Dime — ADK Agent Architecture

## Core Principle

Agents are workers, not orchestrators. The state machine in the API layer decides what runs next. Agents run, write output, emit a checkpoint event, and exit cleanly. No agent ever waits for human input.

## Agent Directory

```
dime/
  agents/
    research_agent.py       LlmAgent  — web research → research.md
    writer_agent.py         LlmAgent  — research.md → article draft.md
    art_director_agent.py   LlmAgent  — draft.md + style guide → prompts
    image_agent.py          LlmAgent  — prompt + slot spec → image variants in art/
    publisher_agent.py      (no LLM)  — calls PublishingAdapter, records publish_event

  tools/
    filesystem_tools.py     read/write via FileSystemAdapter
    versioning_tools.py     commit, get_hash via VersioningAdapter
    image_tools.py          call Imagen API, save variants
    db_tools.py             update article state, record checkpoints
    web_tools.py            search, fetch URL, extract citations
    style_guide_tools.py    read project style guide + slot definitions
    content_guide_tools.py  read project content_guide (audience, voice, standards)
```

Each agent receives only the tools relevant to its task. `ResearchAgent` has no write-draft tool. `WriterAgent` has no web-search tool. Constrained tool sets limit hallucination surface.

`ResearchAgent` and `WriterAgent` both receive `content_guide_tools` — the project's editorial configuration (audience, voice, quality standards, article type specs) is injected into their context at task start. This is what makes output match the publication's voice. Different projects configure different guides; agents hardcode nothing about editorial style.

## Task Lifecycle

```
Broker dispatches: {"type": "research", "article_id": "..."}
  → Worker picks up task
  → ADK LlmAgent runs with its tool set
  → Streams progress events to broker → API → WebSocket → UI
  → Writes output to filesystem via FileSystemAdapter
  → Updates article state in DB
  → Emits: {"article_id": "...", "state": "research_review"}
  → Task complete. Worker exits.
```

Human approves in UI → API dispatches next task → next agent runs.

## Publishing Adapter Protocol

```python
class PublishingAdapter(Protocol):
    name: str
    version: str

    def publish(
        self,
        article_path: Path,
        assets: list[Path],
        metadata: ArticleMetadata,
        options: PublishOptions,
    ) -> PublishResult: ...

    def unpublish(self, slug: str) -> UnpublishResult: ...
    def preview_url(self, slug: str) -> str | None: ...
    def status(self, slug: str) -> PublishStatus: ...
```

`PublishOptions`:
- `signal`: `"cli" | "webhook" | "api_call" | None`
- `schedule_at`: datetime — publish at a future time
- `dry_run`: bool — validate without publishing

Adapters registered by string key. `project.default_adapter = "hugo"`. Adding an adapter = one new file in `dime/adapters/`, no core changes.

## HugoAdapter (first implementation)

1. Copy `article.md` → `hugo_content_dir/posts/`
2. Copy assets → `hugo_static_dir/images/{slug}/`
3. Signal: `hugo --minify` (cli) / POST to webhook / call API endpoint
4. Return `PublishResult(url, timestamp)`
5. `preview_url()` → `http://localhost:1313/posts/{slug}` if dev server running, else `None`

## Scheduler

Scheduled tasks (e.g., "research X every Monday") are managed by the broker's scheduling mechanism — not by an ADK agent. Agents don't schedule themselves.
