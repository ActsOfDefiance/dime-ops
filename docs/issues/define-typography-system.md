# Issue: Define typography system

**Type:** design
**Priority:** medium
**Repo:** acts-of-defiance
**GitHub:** ActsOfDefiance/acts-of-defiance#6
**Epic:** epic-acts-of-defiance

## Goal

The site currently has two undocumented H2 treatments in the wild and no written spec for headline hierarchy, section heads, body text, labels, captions, or pullquotes. This ticket captures the work to design a complete typography system and ship it as both documentation and code.

**This is primarily a design task — Stitch can (and probably should) do the bulk of the work.** Generate the typographic scale and hierarchy in Stitch, apply it to the v2/v3 comps to verify it works across all existing page templates, then hand the tokens back here for implementation.

## Current state (undocumented)

### H1 — page heroes
| Page | Classes |
|---|---|
| Home hero | `text-5xl md:text-7xl lg:text-8xl font-black leading-none tracking-tighter uppercase` Montserrat, white |
| Category page | `text-7xl md:text-9xl font-black leading-none tracking-tighter uppercase` Montserrat, in category accent color |
| Article page | `text-4xl md:text-6xl font-black leading-none tracking-tighter uppercase` Montserrat |
| About page | `text-4xl md:text-6xl font-black leading-none tracking-tighter uppercase` Montserrat |

Three different sizes, no documented rule for when to use which.

### H2 — section heads (two styles in use)

**Style A — Editorial (italic Newsreader, larger)**
- `text-4xl md:text-5xl italic` + Newsreader serif
- Home "Recent stories", About "What we cover", article comp "Go deeper"

**Style B — Structural (Montserrat black uppercase, smaller)**
- `text-3xl font-black uppercase tracking-tighter` + Montserrat
- Article "More acts of defiance", v3 home "Join the Defiance" newsletter CTA

**Inferred (but undocumented) rule:** Style A introduces a list of content as the editorial voice of the publication. Style B closes a page with related content or a CTA in the structural voice.

This is a fragile convention that will drift the moment someone adds a new section head without checking all three comps.

### Body, prose, labels, captions — also undocumented
- Article body prose (`article-body` / `manifesto-body` scoped styles in `[slug].astro` and `about.astro`) — duplicated, not DRY, slightly divergent
- Tagline/subhead: Newsreader italic at varying sizes (`text-xl md:text-2xl`, `text-2xl md:text-3xl`)
- Tag chips, date stamps, byline: inconsistent weights and sizes
- Blockquote treatment: defined only in `[slug].astro` scoped style

## Scope

Deliver a complete typographic system covering every text style used on the site.

### Foundations (decide before generating values)

- [ ] **Pick a modular scale ratio** and document the choice. Candidates: Major Third (1.25), Perfect Fourth (1.333), Augmented Fourth (1.414). Recommended: **Perfect Fourth (1.333)** — punchy display sizes without runaway H1s, defensible for an editorial publication. Every step in the scale must be derivable from the ratio + base size, not invented per-step.
- [ ] **Use fluid type, not stepped breakpoints.** Each step is defined as a single `clamp(min, vw-based, max)` value, not three Tailwind breakpoint variants. This kills the current `text-5xl md:text-7xl lg:text-8xl` pattern that produced four different undocumented H1s. Reference: utopia.fyi for the math.
- [ ] **Acknowledge the spacing-rhythm dependency.** Type and spacing are coupled — leading defines vertical rhythm and vertical rhythm defines the spacing scale. This ticket does not deliver the spacing system, but it MUST establish the leading values that the spacing ticket will derive from. See `define-spacing-system.md` (sibling ticket).

### Design work (Stitch)

- [ ] Define the full type scale (display, H1, H2, H3, H4, body-lg, body, small, caption) with font-family, fluid size (`clamp()`), weight, line-height, letter-spacing per step — all sizes derived from the chosen ratio
- [ ] Define section-head variants with clear usage rules (when to use editorial vs. structural)
- [ ] Define prose styles: first-paragraph treatment, body paragraph, blockquote, inline emphasis, links, inline code
- [ ] Define label styles: category chips, tags, date stamps, bylines, CTAs, nav links
- [ ] Apply the proposed system to the existing v2 comps (home, article, category) and v3 home to verify it works without breaking any existing layout

### Implementation work

- [ ] Add `--text-*` custom properties to `src/styles/global.css` `@theme` block so the scale is accessible as Tailwind utilities
- [ ] Create `src/components/SectionHead.astro` with an explicit `variant` prop (`"editorial" | "structural"`), so the rule is enforced at the code level
- [ ] Extract prose styles into a shared CSS module or Tailwind `@utility` so `[slug].astro` and `about.astro` (and any future article-body page) stop duplicating them
- [ ] Refactor every existing `h1`/`h2`/`h3` on every page to use the new scale — no more hand-tuned `text-4xl md:text-6xl` strings
- [ ] Delete the duplicated `article-body` / `manifesto-body` scoped CSS blocks once the shared prose style lands

### Documentation work

- [ ] Write `docs/specs/typography.md` with the complete spec, usage rules, and examples
- [ ] Reference from `docs/specs/design-standards.md`
- [ ] Update `CLAUDE.md` with a short pointer so future work uses the system

## Acceptance criteria

- [ ] `docs/specs/typography.md` exists and documents the full scale
- [ ] `SectionHead.astro` exists and is used on every section head in the site
- [ ] Prose styles are defined once, not per-page
- [ ] Every page (home, category, article, about) uses the new system — no ad-hoc `text-Xxl font-black` classes in page files
- [ ] WCAG 2.2 AA: all body text is ≥16px, line-height ≥1.5 for prose, color contrast ≥4.5:1 (normal text) or ≥3:1 (large text)
- [ ] Responsive: the scale adapts cleanly from 360px → 1920px without overflow or layout breaks (verified by resizing, not by per-breakpoint tuning — fluid `clamp()` should handle the entire range)
- [ ] Modular scale ratio is documented in `typography.md`; every step's size is derivable from `base × ratio^n`
- [ ] `bun run build` succeeds with no type errors
- [ ] Visual regression: home, category, article, and about pages still match their v2/v3 comps after the refactor

## Sibling tickets in the design system

This is the first ticket in a sequence under acts-of-defiance#2:

- #6 (this) — typography *(foundation)*
- #7 — spacing & vertical rhythm *(depends on this)*
- #8 — motion
- #9 — layout primitives *(depends on spacing)*
- #10 — buttons & links *(depends on this and motion)*

Templates consume all of the above — see `docs/specs/page-templates.md`.

## References

- Current comps: `../art/comps/v2/{home,article,category}.html`, `../art/comps/v3/home.html`
- Memory: `reference_stitch_comps_v2.md` — existing design tokens
- Fonts already loaded in `BaseLayout.astro`: Montserrat 700/800/900, Inter 400/500/600, Newsreader italic
- Modular scale math: utopia.fyi (fluid type calculator)
