# Issue: Set up Acts of Defiance site

**Type:** feature
**Priority:** medium
**Repo:** acts-of-defiance
**Epic:** epic-acts-of-defiance
**Blocked by:** DECISION-003 (Hugo vs Astro)

## If Hugo (current default)

- [ ] Initialize Hugo site in `acts-of-defiance/` repo
- [ ] Choose and configure base theme (or custom — TBD at time of work)
- [ ] Configure `config.toml` / `hugo.toml`: site title, base URL, content structure
- [ ] Content directory structure:
  ```
  content/
    articles/       ← dime publishes here
    about/
  static/
    images/
      articles/     ← image files placed here by HugoAdapter
  ```
- [ ] Local preview: `hugo server` works
- [ ] `hugo --minify` build produces valid static site

## If Astro (if DECISION-003 goes that way)

- [ ] Initialize Astro project with Bun
- [ ] Content collections for articles
- [ ] Equivalent directory structure for dime adapter compatibility
- [ ] `bun run dev` and `bun run build` work

## Both paths

- [ ] Verify HugoAdapter (or equivalent) output is compatible with the chosen SSG's content structure
- [ ] At least one test article renders correctly end-to-end
- [ ] `acts-of-defiance/` repo has its own CLAUDE.md with SSG-specific context
- [ ] CI: GitHub Actions builds the site on push to main

## Note

If Astro migration is planned for the near term (per DECISION-003), invest minimal effort in Hugo theming — just enough to get dime publishing working. Don't over-invest in a theme that will be replaced.
