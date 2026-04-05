# Acts of Defiance — Site Information Architecture

## Navigation

**Top-level nav:** minimal, declarative labels.

```
[Logo/Wordmark]    Artists    Movements    Organizations    People    About
```

- No dropdown menus
- Each category leads to a feed-style listing page
- "About" is the only non-category page in primary nav
- Mobile: hamburger menu with the same flat structure

## Page Hierarchy

| Page | URL | Purpose |
|---|---|---|
| Home | `/` | Featured article hero + curated feed of recent articles |
| Category | `/artists/`, `/movements/`, etc. | Feed of articles in that category, filterable by tags |
| Article | `/{category}/{slug}/` | Full article, nested under its category |
| Tag | `/tags/{tag}/` | All articles with that tag, across categories |
| About | `/about/` | Mission, voice, who we are |

### Home page structure

1. **Featured hero** — one editorially curated article, full-width illustration, declarative headline
2. **Recent feed** — chronological or curated mix of articles across all categories, card layout
3. **Category tiles** — the four categories as visual entry points (per GH issue #1), positioned below the fold as an alternate navigation path

### Category pages

- Feed-style listing of articles in that category
- Tag filtering — click a tag to narrow within the category
- Sort: newest first (default), no other sort options needed initially
- Category description at top — declarative voice, one or two sentences

### Article pages

- Hero illustration (full-width or contained)
- Title, category chip, date, tags
- Article body — long-form markdown rendered content
- Pull quotes styled per visual design language
- Related articles at bottom (same category or shared tags)

### Tag pages

- Cross-category — shows all articles with that tag regardless of category
- Header: "Everything we've written about {tag}." (brand voice)
- Same card layout as category pages

### About page

- Mission statement in brand voice
- Brief explanation of what Acts of Defiance is
- Connection to the broader project (dime, open source)
- No team bios (consensus-driven open source project — "we" language)

## Taxonomy

### Categories (structural, fixed)

| Category | Scope |
|---|---|
| Artists | Musicians, bands, visual artists, art collectives — people who used art as a medium of defiance |
| Movements | Organized collective action, historical and contemporary |
| Organizations | Formal groups, unions, NGOs, political organizations |
| People | Individuals whose defiance shaped history |

Every article belongs to exactly one category. Category is set by dime's agents during content creation and written to frontmatter by the AstroAdapter.

### Tags (emergent, grow organically)

Tags provide cross-cutting navigation. Examples:

- **Subject:** `labor-rights`, `civil-rights`, `anti-colonialism`, `feminism`, `environmental-justice`
- **Era:** `19th-century`, `1960s`, `contemporary`
- **Region:** `united-states`, `latin-america`, `africa`, `global`

An article can have many tags. Tags are not required — some articles may have none initially. New tags emerge as content is created; there is no fixed tag vocabulary.

Tag format: kebab-case, lowercase.

## Content Collections (Astro)

All articles live in a flat directory. Category is determined by frontmatter, not file structure.

```
src/content/
  articles/
    diego-rivera.md
    nina-simone.md
    iww.md
    frantz-fanon.md
    aclu.md
```

### Frontmatter schema

```yaml
---
title: "Frantz Fanon"
description: "The psychiatrist who diagnosed colonialism."
date: 2026-04-01
category: "people"
tags: ["anti-colonialism", "20th-century", "africa", "caribbean"]
images:
  hero: "/images/articles/frantz-fanon/hero.jpg"
draft: false
---
```

Content is created by dime agents and placed by the AstroAdapter. The site reads from this directory — it does not create or modify content.

## URL Structure

Clean, readable, no dates in URLs:

- `/{category}/{slug}/` — e.g., `/people/frantz-fanon/`
- `/tags/{tag}/` — e.g., `/tags/labor-rights/`
- `/about/`

Slugs derived from title, kebab-case. No encoded characters in URLs.

## Routing (Astro)

- `src/pages/index.astro` — home page
- `src/pages/[category]/index.astro` — category listing (dynamic route)
- `src/pages/[category]/[slug].astro` — article page (dynamic route)
- `src/pages/tags/[tag].astro` — tag listing (dynamic route)
- `src/pages/about.astro` — about page

Category and slug are validated against the content collection at build time. Invalid URLs produce 404s.

## Progressive Enhancement Path

The site starts as a purely static Astro build. Future interactive features (per DECISION-003 rationale) may include:

- Rating systems on articles
- User accounts and reading lists
- Interactive components within articles (timelines, maps)
- Community engagement features

These would require flipping Astro to SSR mode (`output: 'server'`) and adding server-side infrastructure. The IA and URL structure are designed to accommodate this without breaking existing URLs.
