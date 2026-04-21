# Issue: Set up Acts of Defiance site

**Type:** feature
**Priority:** medium
**Repo:** acts-of-defiance
**Epic:** epic-acts-of-defiance

## Setup

- [ ] Initialize Astro project with Bun and Svelte 5 integration
- [ ] Configure `astro.config.mjs`: site title, base URL, Svelte integration
- [ ] Content collections for articles in `src/content/`
- [ ] Directory structure:
  ```
  src/
    content/
      articles/       ← dime publishes here
      about/
  public/
    images/
      articles/       ← image files placed here by AstroAdapter
  ```
- [ ] Local preview: `bun run dev` works
- [ ] `bun run build` produces valid static site

## Integration

- [ ] Verify AstroAdapter output is compatible with Astro content collection structure
- [ ] At least one test article renders correctly end-to-end
- [ ] `acts-of-defiance/` repo has its own CLAUDE.md with Astro-specific context
- [ ] CI: GitHub Actions builds the site on push to main

## Acceptance criteria

- [ ] `bun run dev` starts Astro dev server with no errors
- [ ] `bun run build` produces a valid static site
- [ ] Content collections schema validates article frontmatter
- [ ] AstroAdapter-emitted markdown renders correctly in the built site
- [ ] At least one test article visible in local dev server
