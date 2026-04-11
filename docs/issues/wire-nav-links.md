# Issue: Wire up nav links to real destinations

**Type:** maintenance
**Priority:** medium
**Repo:** acts-of-defiance
**GitHub:** ActsOfDefiance/acts-of-defiance#5
**Epic:** epic-acts-of-defiance
**Blocked by:** build-category-pages, build-about-page

## Goal

The header nav already points at `/artists`, `/movements`, `/organizations`, `/people`, and `/about`, but those routes 404 today. Once the category and about pages exist, this is a thin verification + cleanup pass to make sure every nav surface in the site lands somewhere real.

## Tasks

- [ ] Verify all five desktop nav links in `src/components/Header.astro` resolve to real routes
- [ ] Verify the mobile menu (hamburger panel) links resolve to the same routes
- [ ] Verify the footer links in `src/components/Footer.astro` — replace any `href="#"` placeholders with real routes
- [ ] Verify the "Explore Archive" link on the home page Recent stories section points somewhere meaningful (e.g. an `/archive` route, or remove if not building one yet)
- [ ] Verify the home page hero CTA "Read the Manifesto" → `/about` works end-to-end
- [ ] Active state: each nav link must show `aria-current="page"` and the gold underline on its own page (the `isActive()` helper in `Header.astro` already handles this — just confirm it works for each route)

## Acceptance criteria

- [ ] No `href="#"` placeholders remain in `Header.astro` or `Footer.astro`
- [ ] Click every nav link from each page in the site — no 404s, no console errors
- [ ] Active page state highlights correctly on all five top-level pages (home, four categories, about)
- [ ] Keyboard tab order through the nav is sensible
- [ ] `bun run build` succeeds and `dist/` contains all expected `index.html` files
