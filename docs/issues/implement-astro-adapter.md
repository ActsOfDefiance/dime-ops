# Issue: Implement Astro publishing adapter

**Type:** feature
**Priority:** high
**Repo:** dime
**Epic:** epic-dime-core
**Blocked by:** implement-adapters (AstroAdapter implements PublishingAdapter Protocol)

## What it does

`AstroAdapter` is the concrete implementation of `PublishingAdapter` for the acts-of-defiance site. It:
1. Copies images from the local `art/` directory into `acts-of-defiance/public/images/articles/{article_id}/`
2. Writes a signal file to trigger an Astro build (or triggers a webhook/CI run)
3. Records the publish event via API

Markdown is **not** copied — Astro reads it directly from `compendium/` at build time (DECISION-012). AstroAdapter does not touch `src/content/`.

Images are **not** downloaded from GCS — they are read from the local `art/` filesystem (DECISION-013). The Astro `<Image>` component handles resize/optimization at build time.

## Configuration

Injected at runtime — no hardcoded paths:
- `art_dir` — path to the local `art/` directory
- `acts_of_defiance_public_dir` — path to `acts-of-defiance/public/images/`
- `signal_file_path` — where to write the publish signal

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
