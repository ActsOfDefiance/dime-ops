# Issue: Define button & link system

**Type:** design
**Priority:** medium — needed before newsletter CTA / share buttons / any interactive ticket
**Repo:** acts-of-defiance
**Epic:** Epic: Design (acts-of-defiance#2)
**Depends on:** define-typography-system.md, define-motion-system.md

## Goal

A single `<Button>` component with documented variants and states, plus a documented link style. Replaces the ad-hoc anchor styling currently scattered across header nav, footer, hero CTA, and article CTAs.

## Scope

### Variants
- [ ] `primary` — revolutionary red, white text, the dominant CTA
- [ ] `secondary` — warm gold, charcoal text, for secondary actions
- [ ] `ghost` — transparent with border, for tertiary or destructive
- [ ] `link` — text-only, used inline in prose

### Sizes
- [ ] `sm`, `md` (default), `lg` — sized via typography + spacing tokens, not literal padding

### States
- [ ] hover, focus-visible, active, disabled — all using motion tokens
- [ ] focus-visible ring meets AA contrast against every background it appears on

### Anchor vs button
- [ ] `<Button>` accepts `href` and renders an `<a>` when present, `<button>` otherwise — semantics matter
- [ ] Inline link style (in prose) is documented separately and lives in the prose utility

### Implementation
- [ ] `src/components/Button.astro`
- [ ] Refactor existing CTAs (hero, newsletter, "read more", header nav) to use it
- [ ] Document in `docs/specs/buttons.md`

## Acceptance criteria

- [ ] `<Button>` exists with all four variants and three sizes
- [ ] Every CTA in every page uses `<Button>` — no raw `<a class="bg-revolutionary-red ...">` anywhere
- [ ] Focus-visible verified with keyboard navigation across all variants and backgrounds
- [ ] AA contrast verified for every variant
