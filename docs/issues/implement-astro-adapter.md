# Issue: Implement Astro publishing adapter

**Type:** feature
**Priority:** high
**Repo:** dime
**Epic:** epic-dime-core
**Blocked by:** implement-adapters (AstroAdapter implements PublishingAdapter Protocol)

## What it does

`AstroAdapter` is the concrete implementation of `PublishingAdapter` for the acts-of-defiance site. It:
1. Writes the article markdown to the acts-of-defiance `src/content/` directory using Astro Content Collections
2. Generates Astro Content Collections frontmatter (title, date, tags, image references, etc.) as YAML
3. Downloads images from GCS and places them in the site public directory (or references GCS URLs directly)
4. Writes a signal file to trigger Astro rebuild (or triggers a webhook/CI run)
5. Records the publish event via API

## Configuration

Injected at runtime — no hardcoded paths:
- `acts_of_defiance_content_dir` — path to `acts-of-defiance/src/content/`
- `acts_of_defiance_public_dir` — path to `acts-of-defiance/public/images/`
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

Implement `preview_url()` to return a local Astro dev server URL if running locally. This enables the Package Dashboard to show a live preview link.

## Acceptance criteria

- [ ] `AstroAdapter` satisfies `PublishingAdapter` Protocol (pyright validates this)
- [ ] Emits valid Astro-compatible markdown: `bun run build` passes on the output
- [ ] Frontmatter is complete and correctly formatted per Astro Content Collections schema
- [ ] Images referenced in frontmatter exist at stated paths
- [ ] Signal file written after successful emit
- [ ] `pytest tests/test_astro_adapter.py` — writes to temp directory, validates output
- [ ] Idempotent: running emit twice for the same article does not duplicate content

## Notes

See `docs/design/aod-visual-design.md` (Image Inventory section) for Acts of Defiance image dimensions and aspect ratios. The hero image slot is `21:9` at `2560×1097`. Card thumbnails are derived from the hero by Astro at build time — no separate thumbnail generation needed. See `docs/design/aod-site-architecture.md` for the Astro Content Collection frontmatter schema.
