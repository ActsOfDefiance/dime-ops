# Epic: Acts of Defiance Site

**Type:** feature
**Priority:** medium — needs dime-core publishing adapter working
**Blocked by:** epic-dime-core (AstroAdapter must emit valid content)

## Goal

A live Acts of Defiance publication. Content flows from dime through the Astro adapter into the acts-of-defiance repo. Site builds and deploys. The content guide shapes all output.

## Sub-issues

### Site setup
- [ ] [set-up-acts-of-defiance-site.md](set-up-acts-of-defiance-site.md) — Astro scaffold with Svelte 5, content collections, local preview
- [x] [build-category-pages.md](build-category-pages.md) — `/artists`, `/movements`, `/organizations`, `/people` landing pages
- [x] [build-about-page.md](build-about-page.md) — `/about` page (destination for the home hero CTA)
- [ ] [wire-nav-links.md](wire-nav-links.md) — verification pass: no `href="#"` placeholders, no 404s, active state works on every page

### Publishing integration
- [ ] [wire-content-pipeline-to-astro.md](wire-content-pipeline-to-astro.md) — point content collections at compendium/, copy images from art/, `bun run build` produces a site with real content (#20)
- [ ] Verify AstroAdapter output matches Astro content collection structure (depends on: implement-astro-adapter in epic-dime-core)
- [ ] End-to-end test: dime emits article → acts-of-defiance builds → site renders correctly
- [ ] Configure image sizes and crop targets for Acts of Defiance (feeds back to image_slot config in dime)

### Content guide
- [ ] Review and finalize `docs/projects/acts-of-defiance/content-guide.md` — this is injected into agent context for every article
- [ ] Wire content guide to dime project record (project.content_guide JSONB in DB)

### Deployment
- [ ] Configure Astro build in CI (GitHub Actions on acts-of-defiance repo)
- [ ] Deploy to hosting (GCP Cloud Storage + CDN, or Netlify/Vercel — decide at time of work)

## Order

```
set-up-acts-of-defiance-site
    ↓ (parallel)
build-category-pages + build-about-page
    ↓
wire-nav-links (cleanup)
    ↓ (parallel with adapter work)
verify AstroAdapter output + configure image sizes
review content guide
    ↓
end-to-end publish test
    ↓
CI build + deploy
```

## Definition of Done

- [ ] `bun run dev` runs locally with no errors
- [ ] dime can publish a test article end-to-end: queued → published → visible in local site build
- [ ] Image slots render at correct dimensions in built site
- [ ] content_guide values (audience, voice, standards) are flowing into agent prompts
- [ ] Site builds in CI on push to main
- [ ] Published articles have correct frontmatter, citations, and image references
