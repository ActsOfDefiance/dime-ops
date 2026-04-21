# Page Template Strategy

Acts of Defiance uses **page templates** as the composition layer above components. Templates define the contract between dime's content output and the rendered page. Components are atomic vocabulary; templates are how the publication actually renders.

## Why templates over strict atomic design

Atomic design (atoms → molecules → organisms → templates → pages) is useful as vocabulary but pedantic as a folder structure. For a content-driven publication, the meaningful coupling lives at the template layer: dime's AstroAdapter emits content into a content collection, and a template renders it. The atom/molecule debate is academic; the template/content contract is load-bearing.

Folder convention:
- `src/components/` — flat, self-naming (`Button.astro`, `SectionHead.astro`, `ArticleCard.astro`, `SiteHeader.astro`)
- `src/layouts/` — page templates (`ArticleTemplate.astro`, `CategoryTemplate.astro`, `HomeTemplate.astro`, `AboutTemplate.astro`) plus `BaseLayout.astro` as the HTML shell

## Templates

### BaseLayout
The HTML shell. Owns `<head>`, fonts, global CSS, `SiteHeader`, `SiteFooter`, `<slot />`. Every template wraps in this. **Already exists.**

### HomeTemplate
- Hero (headline + tagline + sunburst)
- Featured article (hero card)
- Recent stories grid (article cards, paginated or capped)
- Section heads use `editorial` variant
- Composes: `Container`, `Stack`, `Grid`, `ArticleCard`, `SectionHead`

### CategoryTemplate
- Category hero (oversized H1 in category accent color)
- Optional category description
- Article grid filtered to that category
- Props: `category` (one of the four enum values)
- Composes: `Container`, `Stack`, `Grid`, `ArticleCard`, `SectionHead`

### ArticleTemplate
- Article hero (image + headline + byline + date + category chip)
- Prose body (rendered from collection entry, uses shared prose utility)
- Pull quotes inline
- "More acts of defiance" related-content section (`structural` variant section head)
- Props: `entry` (CollectionEntry<'articles'>)
- Composes: `Container` (prose width), `Stack`, `SectionHead`, `Button`, prose utility

### AboutTemplate
- Page hero (oversized H1)
- Manifesto-style prose body (single column, prose width)
- "What we cover" sections (`editorial` variant section head)
- Composes: `Container` (prose width), `Stack`, `SectionHead`, prose utility

## Contract with dime

Dime's AstroAdapter emits markdown into `src/content/articles/`. The article frontmatter schema (defined in `src/content.config.ts`) is the contract — adapter must produce valid frontmatter, template renders whatever validates. Schema changes are coordinated changes between repos.

The adapter does NOT know about templates. It produces content; the site decides how to render it. This decoupling is the whole point of the static-site / pluggable-adapter architecture.

## What templates do NOT do

- Templates do not own data fetching beyond `getCollection()` / `getEntry()` — there's no API layer
- Templates do not own global state — Svelte islands handle local state where needed
- Templates do not duplicate prose styles — shared prose utility is used
- Templates do not contain literal spacing values — they compose layout primitives

## When to add a new template

Add a new template when a page type has:
- A distinct content shape (different frontmatter schema, different collection)
- A repeated layout that doesn't fit existing templates

Don't add a template for one-off pages — use `Container` + primitives directly in the page file.

## Relationship to design system tickets

- Typography → defines what `SectionHead`, prose, headings look like
- Spacing → defines what `Stack`, `Container` gaps and padding consume
- Motion → defines hover/focus states templates apply to interactive elements
- Layout primitives → are the building blocks templates compose
- Buttons → are the CTA primitive templates use

Templates are the consumer of the design system. The design system tickets must land before templates can be cleanly refactored.
