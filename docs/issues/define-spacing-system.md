# Issue: Define spacing & vertical rhythm system

**Type:** design
**Priority:** medium — depends on typography
**Repo:** acts-of-defiance
**Epic:** Epic: Design (acts-of-defiance#2)
**Depends on:** define-typography-system.md

## Goal

A coherent spacing scale derived from typographic vertical rhythm, replacing ad-hoc `mt-12 mb-8 px-6` strings sprinkled across page templates. Spacing is the second half of typography — leading defines rhythm, rhythm defines the spacing scale.

## Why this matters

Without a spacing system, the typography work is undermined the moment someone reintroduces hand-tuned margins. A type scale without a spacing scale produces visually inconsistent pages even when the headings are correct.

## Scope

### Foundations
- [ ] Pick a base unit (typically the body line-height in px, e.g., 28px for 18px/1.55 body) — this becomes the rhythm unit
- [ ] Define a spacing scale derived from the base unit: `--space-3xs, 2xs, xs, sm, md, lg, xl, 2xl, 3xl` (or similar) — every value is `base × n` or `base × ratio^n`
- [ ] Decide whether spacing is fluid (clamp-based) or stepped — recommendation: stepped for spacing, fluid for type, since stepped spacing is more predictable in grids

### Design work
- [ ] Define semantic spacing tokens layered on the scale: `--space-section-y` (between major sections), `--space-stack` (between stacked content), `--space-inline` (between inline elements), `--space-prose-paragraph` (between body paragraphs)
- [ ] Define container max-widths for prose vs full-width sections
- [ ] Apply the system to v2/v3 comps and verify

### Implementation
- [ ] Add `--space-*` custom properties to `global.css` `@theme`
- [ ] Refactor every page template to use semantic spacing tokens — no more `mt-12 mb-8` literals
- [ ] Document in `docs/specs/spacing.md`

## Acceptance criteria

- [ ] `docs/specs/spacing.md` exists and documents the scale, base unit, and rhythm relationship to typography
- [ ] Every margin/padding in page templates uses a `--space-*` token or its Tailwind equivalent
- [ ] `bun run build` succeeds; visual regression: pages still match comps
