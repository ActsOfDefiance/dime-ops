# Issue: Define layout primitives

**Type:** design / refactor
**Priority:** medium — depends on spacing system
**Repo:** acts-of-defiance
**Epic:** Epic: Design (acts-of-defiance#2)
**Depends on:** define-spacing-system.md

## Goal

A small set of composable layout primitive components (Container, Stack, Cluster, Grid) that absorb the layout logic currently scattered across page templates as ad-hoc flex/grid utility classes.

## Why

Page templates today repeat patterns like `<div class="max-w-4xl mx-auto px-8 space-y-12">` and `<div class="grid grid-cols-1 md:grid-cols-3 gap-8">`. These should be named primitives so:
- The intent is in the component name, not utility soup
- Spacing tokens are enforced (not literal `gap-8`)
- New page templates compose primitives instead of reinventing layouts

Reference: every-layout.dev — the canonical source for this pattern.

## Scope

### Components (Astro)
- [ ] `<Container>` — max-width + horizontal padding wrapper. Variants: `prose` (narrower), `wide` (default), `full`
- [ ] `<Stack>` — vertical rhythm with token-based gap. Prop: `gap` (defaults to `--space-md`)
- [ ] `<Cluster>` — wrapping inline group (chips, tags, links). Prop: `gap`
- [ ] `<Grid>` — responsive auto-fit grid. Props: `min` (column min-width), `gap`
- [ ] `<Center>` — centers content horizontally; combines with Container for the common case

### Refactor
- [ ] Refactor `index.astro`, category page, article page, about page to compose primitives instead of utility-class layouts
- [ ] Document in `docs/specs/layout.md` with usage examples

## Acceptance criteria

- [ ] All five primitives exist in `src/components/layout/`
- [ ] No page template contains a raw `max-w-* mx-auto px-*` block — Container handles it
- [ ] No page template contains a raw `space-y-*` or `gap-*` literal — primitives consume tokens
- [ ] `bun run build` succeeds; visual regression passes
