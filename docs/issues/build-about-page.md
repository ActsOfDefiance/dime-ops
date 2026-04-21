# Issue: Build About page

**Type:** feature
**Priority:** medium
**Repo:** acts-of-defiance
**GitHub:** ActsOfDefiance/acts-of-defiance#4
**Epic:** epic-acts-of-defiance
**Depends on:** set-up-acts-of-defiance-site

## Goal

Create the `/about` page so the existing nav link resolves and visitors can read the publication's manifesto, mission, and origin.

## Source content

- [x] Pull the body copy from `src/content/about/` (collection already exists with a placeholder `index.md`). Define a small `about` collection schema if needed (title, description, sections).
- [x] Or hard-code the copy in `src/pages/about.astro` if a collection feels like overkill for a single static page.

## Page structure

- [x] `src/pages/about.astro`
- [x] Header (existing `Header.astro`)
- [x] Page hero/intro: large Montserrat headline + Newsreader italic subhead
- [x] Body section: typeset prose, similar to the article body styling (`max-w-[700px]`, parchment background) — reuse the article-body CSS pattern from `[slug].astro`
- [x] Optional: a simple "What we cover" section that links to the four category pages
- [x] Footer (existing `Footer.astro`)

## Reference

- Comps: `../art/comps/v2/` — no dedicated about comp; pull layout cues from `home.html` (hero) and `article.html` (body prose)
- The "Read the Manifesto" CTA on the home page hero already points to `/about`, so this page is the destination for that primary action

## Acceptance criteria

- [x] `/about` resolves with no 404
- [x] Page reads as a coherent statement of purpose (the manifesto), not boilerplate
- [x] Active nav link shows `aria-current="page"` and gold underline when on `/about`
- [x] `bun run build` succeeds with the route generated
- [x] WCAG 2.2 AA: heading hierarchy starts at h1, semantic landmarks (`main`, `article`), focusable elements have visible focus rings
