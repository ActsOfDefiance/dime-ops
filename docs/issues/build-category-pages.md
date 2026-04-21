# Issue: Build category landing pages

**Type:** feature
**Priority:** medium
**Repo:** acts-of-defiance
**GitHub:** ActsOfDefiance/acts-of-defiance#3
**Epic:** epic-acts-of-defiance
**Depends on:** set-up-acts-of-defiance-site

## Goal

Add a landing page for each of the four content categories so the nav links resolve to real pages and visitors can browse the archive by category.

## Pages to build

- [ ] `/artists` — `src/pages/artists.astro` (or `src/pages/categories/artists.astro`)
- [ ] `/movements` — `src/pages/movements.astro`
- [ ] `/organizations` — `src/pages/organizations.astro`
- [ ] `/people` — `src/pages/people.astro`

Decide whether to:
- (a) hand-roll four files, or
- (b) use a single dynamic route `src/pages/[category].astro` with `getStaticPaths()` over the category enum.

Option (b) is preferred — less duplication, schema-driven.

## Reference

- Comp: `../art/comps/v2/category.html` — category archive layout
- Memory: `reference_stitch_comps_v2.md` — design tokens
- Existing patterns to mirror: home page (`src/pages/index.astro`) for the article-card grid, recent stories section structure

## Structure

Each category page should include:

- [ ] Header (existing `Header.astro` — already shows active state via `aria-current="page"`)
- [ ] Page title block (Newsreader italic + Montserrat) showing the category name and a one-line description
- [ ] Filtered article grid: same `aspect-[4/5]` card pattern as the home page, but only articles where `data.category === <this category>`
- [ ] Empty state when there are no published articles in the category
- [ ] Footer (existing `Footer.astro`)

## Schema additions (optional)

- [ ] Consider a `src/content/categories/` collection for category metadata (display name, hero image, intro copy, accent color) so colours/intros aren't hard-coded in the page

## Acceptance criteria

- [ ] All four nav links resolve to a working page (no 404s)
- [ ] Each page lists only the articles in its category, sorted by date desc
- [ ] Each page renders the empty state when no articles exist for that category
- [ ] Active nav link shows `aria-current="page"` and the gold underline
- [ ] `bun run build` succeeds with all four routes generated
- [ ] WCAG 2.2 AA: heading hierarchy, keyboard navigation, focus rings, semantic landmarks
