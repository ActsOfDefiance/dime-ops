# Epic: Acts of Defiance Site

**Type:** feature
**Priority:** medium — needs dime-core publishing adapter working
**Blocked by:** epic-dime-core (HugoAdapter must emit valid content)

## Goal

A live Acts of Defiance publication. Content flows from dime through the Hugo adapter into the acts-of-defiance repo. Site builds and deploys. The content guide shapes all output.

## Decisions to resolve first

- [ ] DECISION-003: Hugo (now) vs Astro (future) — decide before investing in Hugo theme work. If migrating to Astro is imminent, do minimum Hugo setup to unblock publishing; invest theme effort in Astro.

## Sub-issues

### Site setup
- [ ] [set-up-acts-of-defiance-site.md](set-up-acts-of-defiance-site.md) — Hugo config, content structure, base theme, local preview; OR Astro scaffold if DECISION-003 goes that way

### Publishing integration
- [ ] Verify HugoAdapter output matches Hugo content structure (depends on: implement-hugo-adapter in epic-dime-core)
- [ ] End-to-end test: dime emits article → acts-of-defiance builds → site renders correctly
- [ ] Configure image sizes and crop targets for Acts of Defiance (feeds back to image_slot config in dime)

### Content guide
- [ ] Review and finalize `docs/projects/acts-of-defiance/content-guide.md` — this is injected into agent context for every article
- [ ] Wire content guide to dime project record (project.content_guide JSONB in DB)

### Deployment
- [ ] Configure Hugo/Astro build in CI (GitHub Actions on acts-of-defiance repo)
- [ ] Deploy to hosting (GCP Cloud Storage + CDN, or Netlify/Vercel — decide at time of work)

## Order

```
DECISION-003
    ↓
set-up-acts-of-defiance-site
    ↓ (parallel)
verify HugoAdapter output + configure image sizes
review content guide
    ↓
end-to-end publish test
    ↓
CI build + deploy
```

## Definition of Done

- [ ] `hugo server` (or `astro dev`) runs locally with no errors
- [ ] dime can publish a test article end-to-end: queued → published → visible in local site build
- [ ] Image slots render at correct dimensions in built site
- [ ] content_guide values (audience, voice, standards) are flowing into agent prompts
- [ ] Site builds in CI on push to main
- [ ] Published articles have correct frontmatter, citations, and image references
