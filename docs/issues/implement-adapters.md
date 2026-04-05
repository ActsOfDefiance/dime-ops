# Issue: Implement pluggable adapters

**Type:** feature
**Priority:** high — all agents and the API depend on adapters
**Repo:** dime
**Epic:** epic-dime-core

## Adapters to implement

All adapters are Python Protocols. Concrete implementations are injected via config, not imported directly.

### BrokerAdapter
**Protocol:** `dispatch_task(task_type, payload)`, `consume(task_type, handler)`
**Default implementation:** Redis Streams (via `redis-py`)
**Alt implementations:** RabbitMQ, GCP Pub/Sub (stubs only, not full implementations)

### FileSystemAdapter
**Protocol:** `read(path)`, `write(path, content)`, `exists(path)`, `list(prefix)`
**Local implementation:** plain filesystem reads/writes relative to compendium/ root
**GCS implementation:** `google-cloud-storage` client; GCS bucket for images (not markdown)
**Note:** Markdown files always go to local filesystem (compendium/ is source of truth). GCS is for images only.

### PublishingAdapter
**Protocol:** `emit(article, images)`, `signal()`, optional `preview_url()`
**Astro implementation:** write markdown to acts-of-defiance `src/content/` dir, write Content Collections frontmatter, write signal file, copy/reference images
**Note:** Astro adapter is the only required implementation. Others are future.

### NotificationAdapter
**Protocol:** `notify(event, user, message)`
**In-app implementation:** WebSocket push via existing FastAPI connection (always active in solo mode)
**Alt stubs:** Slack webhook, Twilio SMS (stubs only — see DECISION-006)

## Implementation structure

```
dime/
  adapters/
    __init__.py
    protocols.py      ← all Protocol definitions
    broker/
      redis.py
    filesystem/
      local.py
      gcs.py
    publishing/
      astro.py
    notification/
      websocket.py
```

## Acceptance criteria

- [ ] `pyright` no errors on all adapter files
- [ ] `pytest tests/test_adapters.py` passes with real Redis (not mocked)
- [ ] BrokerAdapter: dispatch → consume round-trip works
- [ ] FileSystemAdapter local: read/write/list on temp directory
- [ ] FileSystemAdapter GCS: can be instantiated with a test bucket (integration test, gated behind env var)
- [ ] PublishingAdapter Astro: emits valid Astro-compatible markdown with Content Collections frontmatter to temp directory
- [ ] All adapters injectable via `adapter_factory(config)` — no direct imports in agent or API code

## Notes

- Do NOT mock the broker or filesystem in integration tests — we've been burned by this before
- GCS integration tests require `GCS_TEST_BUCKET` env var; skip if not set
