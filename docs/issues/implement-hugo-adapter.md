# Issue: Implement Hugo publishing adapter

**Type:** feature
**Priority:** high
**Repo:** dime
**Epic:** epic-dime-core
**Blocked by:** implement-adapters (HugoAdapter implements PublishingAdapter Protocol)

## What it does

`HugoAdapter` is the concrete implementation of `PublishingAdapter` for the acts-of-defiance site. It:
1. Writes the article markdown to the acts-of-defiance content directory
2. Generates Hugo frontmatter (title, date, tags, image references, etc.)
3. Downloads images from GCS and places them in the site static directory (or references GCS URLs directly)
4. Writes a signal file to trigger Hugo rebuild (or triggers a webhook/CI run)
5. Records the publish event via API

## Configuration

Injected at runtime — no hardcoded paths:
- `acts_of_defiance_content_dir` — path to `acts-of-defiance/content/`
- `acts_of_defiance_static_dir` — path to `acts-of-defiance/static/images/`
- `signal_file_path` — where to write the publish signal
- `image_source` — GCS bucket URI root

## Frontmatter shape

```yaml
---
title: "Article Title"
date: 2026-03-28
draft: false
tags: ["tag1", "tag2"]
images:
  hero: "/images/articles/{article_id}/hero.jpg"
  thumbnail: "/images/articles/{article_id}/thumb.jpg"
description: "First paragraph or explicit excerpt"
author: "Acts of Defiance"
---
```

## Preview support (optional)

Implement `preview_url()` to return a local Hugo server URL if running locally. This enables the Package Dashboard to show a live preview link.

## Acceptance criteria

- [ ] `HugoAdapter` satisfies `PublishingAdapter` Protocol (pyright validates this)
- [ ] Emits valid Hugo markdown: `hugo --dry-run` passes on the output
- [ ] Frontmatter is complete and correctly formatted
- [ ] Images referenced in frontmatter exist at stated paths
- [ ] Signal file written after successful emit
- [ ] `pytest tests/test_hugo_adapter.py` — writes to temp directory, validates output
- [ ] Idempotent: running emit twice for the same article does not duplicate content

## Notes

See `docs/projects/acts-of-defiance/content-guide.md` for Acts of Defiance-specific image size requirements — these must be reflected in the image_slot definitions the adapter expects.
