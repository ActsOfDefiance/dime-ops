# Issue: Wire content pipeline to Astro

**Type:** feature
**Priority:** high
**Repo:** acts-of-defiance
**Epic:** epic-acts-of-defiance
**GitHub:** ActsOfDefiance/acts-of-defiance#20
**Depends on:** DECISION-012, DECISION-013 (both settled)

## Goal

Configure the Astro site to read content from `compendium/` and images from `art/` so that `bun run build` produces a working site with real articles and images in it.

## What needs to happen

### 1. Point content collections at `compendium/`

Configure `astro.config.mjs` to use `compendium/` as the content source instead of `src/content/`. Options:
- Symlink `src/content/articles/` → `compendium/`
- Or set `base` in the content collection config to point at the compendium path

### 2. Update content collection schema

The schema in `src/content/config.ts` (or equivalent) must match the frontmatter shape in compendium articles:

```ts
images: z.object({
  hero: z.string(), // art/ filename — rewritten to public path at publish time
}).optional(),
```

Other fields to validate: `title`, `date`, `category`, `tags`, `description`, `draft`, `status`.

### 3. Copy images from `art/` into `public/images/`

For local dev and build, images need to exist at the paths Astro expects. Write a small build script or `just` task that:
- Reads `images.hero` from each article's frontmatter
- Copies the file from `art/{filename}` → `public/images/articles/{slug}/hero.{ext}`
- Rewrites the frontmatter `images.hero` value to the public path before build (or handle in the Astro component directly)

### 4. Verify article pages render

- Article template reads `images.hero` and passes it to `<Image>`
- Category pages filter articles by `data.category`
- Home page shows articles from the content collection

## Acceptance criteria

- [ ] `bun run build` succeeds with no errors
- [ ] At least one article (e.g. Frantz Fanon) appears on the home page with its hero image
- [ ] `/people/frantz-fanon/` (or equivalent slug) renders the full article
- [ ] Category pages show the correct articles under each category
- [ ] No broken image references in the built output
- [ ] `bun run dev` works for local development with live content

## Notes

- Hero image dimensions: `21:9` at `2560×1097` — see `docs/design/aod-visual-design.md`
- Card thumbnails are derived from the hero by Astro's `<Image>` at build time — no separate copy needed
- Articles without a `category` field in frontmatter will need one added to compendium before they appear on category pages
- The image copy/rewrite step is a local-only concern — the AstroAdapter handles this at publish time in production
