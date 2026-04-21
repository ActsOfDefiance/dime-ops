# Spacing & Vertical Rhythm

The layout rhythm foundation for Acts of Defiance. This is the spec — the code in `src/styles/global.css` `@theme` is the implementation.

**Status:** v1, established by acts-of-defiance#7.
**Depends on:** [typography](./typography.md) (#6 — establishes the line-height values this spec's rhythm is derived from).
**Enables:** [layout primitives](./layout.md) (#9 — consumes the `--container-*` tokens defined here), [buttons](./buttons.md) (#10 — consumes the `--spacing-*` tokens for padding).

---

## Foundations

### Stepped, not fluid

Spacing is **stepped** (a fixed set of values) rather than fluid (`clamp()`-based). Typography is fluid because reading size should scale with viewport; spacing is stepped because grids and vertical rhythm are more predictable with fixed values, and because Tailwind 4's native spacing utilities are stepped — fighting them creates friction for no benefit.

This pairing (fluid type + stepped spacing) is the standard Utopia-adjacent approach. Don't introduce `clamp()` in the spacing scale without a very good reason.

### Atomic base + rhythmic semantic layer

The scale is **atomic** — every value is a multiple of the 4px (0.25rem) atomic unit. This gives the finest-grained control and composes cleanly with Tailwind's default spacing utilities.

On top of that atomic scale, a **rhythmic semantic layer** provides one pinned token — `--spacing-rhythm` at 1.75rem (28px) — which corresponds to exactly one line of body text at the maximum viewport (body font 18px × line-height 1.6 = 28.8 ≈ 28). This is the token used for prose paragraph separation so body text paragraphs sit on vertical rhythm.

The other semantic tokens (section gap, stack gap, container padding, etc.) reference the atomic scale directly. Not every spacing decision needs to be rhythm-aligned — headlines and section breaks can be looser because they're not long-form reading.

### Relationship to typography

From [typography.md](./typography.md):

| Step | Line-height | Height at min base (16px) | Height at max base (18px) |
|---|---|---|---|
| `--text-body` | 1.6 | 25.6px | 28.8px |
| Prose body (in `.prose p`) | 1.75 | 28px | 31.5px |
| `--text-body-lg` | 1.5 | — | 37.5px |
| Headings (h1–h4) | 0.9–1.05 | tight | tight |

The "rhythm unit" (one line of body text) varies from ~26px (small phones) to ~29px (desktop) because body type is fluid. The `--spacing-rhythm` token pins to the max-viewport value (28px) because it's where long-form reading happens and because 28 rounds cleanly.

**Consequence:** prose paragraphs sit exactly on rhythm at desktop; at phone-narrow viewports they sit slightly above rhythm (28px gap ≈ 1.09 lines of 25.6px text). This is an acceptable trade-off and significantly simpler than a fluid rhythm that would couple spacing to the type clamp.

---

## The scale

Every value is `n × 0.25rem` where n is an integer. The scale is a mix of **linear steps at the small end** (0.25 → 1.5) for fine-grained control over tight UI spacing, and **geometric-ish doublings at the large end** (2 → 8) for dramatic section breaks.

| Token | rem | px (default) | Tailwind equivalent | Purpose |
|---|---|---|---|---|
| `--spacing-3xs` | 0.25 | 4 | `p-1` / `gap-1` | Micro gaps (between an icon and adjacent text) |
| `--spacing-2xs` | 0.5 | 8 | `p-2` / `gap-2` | Tight UI gaps (tag chip gap, small inline) |
| `--spacing-xs` | 0.75 | 12 | `p-3` / `gap-3` | Small gaps (inline element spacing, button internal) |
| `--spacing-sm` | 1 | 16 | `p-4` / `gap-4` | Default small spacing (form field gap, tight stack) |
| `--spacing-md` | 1.5 | 24 | `p-6` / `gap-6` | Default medium spacing (container padding, content cluster) |
| `--spacing-rhythm` | 1.75 | 28 | *(not in Tailwind's default)* | **Pinned rhythm.** Prose paragraph separation. One line of body text at max viewport. |
| `--spacing-lg` | 2 | 32 | `p-8` / `gap-8` | Large spacing (card internal padding, nav gap) |
| `--spacing-xl` | 3 | 48 | `p-12` / `gap-12` | Extra-large spacing (hero content block gap, card grid gap) |
| `--spacing-2xl` | 4 | 64 | `p-16` / `gap-16` | Section internal vertical padding |
| `--spacing-3xl` | 6 | 96 | `p-24` / `gap-24` | Between major page sections |
| `--spacing-4xl` | 8 | 128 | `p-32` / `gap-32` | Largest — dramatic spatial break (reserved, not currently used) |

**Why 11 steps?** The scale needs to cover every real usage in the codebase without forcing approximations. The audit of round-1 code found 52 unique spacing utilities; the 11 scale steps cover every common value (4, 8, 12, 16, 24, 28, 32, 48, 64, 96, 128) without gaps that would force `[arbitrary-value]` syntax.

**Why `--spacing-rhythm` is off the geometric pattern.** It's the only pinned-to-typography value in the scale. Every other step is either linear (small end) or a doubling/intermediate (large end). `1.75rem` (28px) slots between `--spacing-md` (24) and `--spacing-lg` (32) and provides the single rhythmic anchor for long-form body text.

---

## Semantic tokens (layered on the scale)

The raw scale is for when you need to pick a precise value. The semantic layer is for when intent matters more than the exact number — use these whenever you can.

| Token | Resolves to | Applies to |
|---|---|---|
| `--spacing-section-y` | `var(--spacing-3xl)` (96px) | Vertical gap between major page sections (home hero → recent stories, recent stories → footer, etc.) |
| `--spacing-stack` | `var(--spacing-lg)` (32px) | Default vertical stack rhythm for content blocks inside a section |
| `--spacing-inline` | `var(--spacing-xs)` (12px) | Default inline element gap (tag rows, chip clusters, button icon spacing) |
| `--spacing-prose-paragraph` | `var(--spacing-rhythm)` (28px) | Body paragraph separation inside `.prose`. Already consumed by `src/styles/prose.css`. |
| `--spacing-container-x` | `var(--spacing-md)` (24px) | Horizontal page padding, mobile baseline. |
| `--spacing-container-x-lg` | `var(--spacing-xl)` (48px) | Horizontal page padding, tablet+ (applied via a media query). |
| `--spacing-card-gap` | `var(--spacing-xl)` (48px) | Grid gap between article cards in recent-stories / category grids. |
| `--spacing-hero-pb` | `var(--spacing-xl)` (48px) | Bottom padding inside a cinematic hero (distance between the CTA and the hero bottom edge). |

**When to use semantic vs raw tokens:**

- **Use semantic tokens by default.** They carry intent and survive scale refactors. If you change `--spacing-section-y` from 96 to 112, every major section gap updates together.
- **Use raw scale tokens** when the spacing isn't "about" any of the semantic concepts. For example, a 32px gap between two badges isn't a "stack" — it's just a gap — so `var(--spacing-lg)` is fine directly.
- **Never use arbitrary values** (`[24px]`, `[1.5rem]`, etc.) for spacing in page templates. If a value you need isn't in the scale, that's a signal either the scale needs updating or you're making a one-off that should become a bespoke token (like `--header-height`).

---

## Container tokens

Max-width tokens for content containers. [Layout primitives #9](./layout.md) will consume these in its `<Container>` component.

| Token | px | Maps from current code | Purpose |
|---|---|---|---|
| `--container-reading` | 700 | `max-w-[700px]` in `Prose.astro` | Long-form reading measure (60–75 characters at body font). The Prose component reading width. |
| `--container-hero` | 896 | `max-w-4xl`, `max-w-3xl`, `max-w-2xl` | Hero content blocks — headline + supporting copy + CTA. Also collapses the earlier `max-w-3xl` taglines and `max-w-2xl` hero descriptions. |
| `--container-content` | 1280 | `max-w-7xl`, `max-w-screen-xl` | Page-width grid containers — recent stories grid, category article grid, article overlap container. |

**Three tokens, not five.** The round-0 code used `max-w-2xl` (672), `max-w-3xl` (768), and `max-w-4xl` (896) in adjacent contexts. The distinction between those three widths was hand-tuned aesthetic, not semantic — all three are "short text blocks inside a hero-like context" — so they collapse to a single `--container-hero` (896). If future work needs a narrower hero subhead, add a fourth `--container-hero-subhead` token then; don't reintroduce raw values.

**Deferred to #9.** The `<Container>` Astro component itself — which consumes these tokens and applies `max-width` plus horizontal padding in one wrapper — ships in the layout primitives ticket. This spec just defines the values.

---

## Usage rules — do this, not that

### ✅ Do

```astro
<!-- Page section vertical padding uses the semantic section token -->
<section style="padding-top: var(--spacing-section-y); padding-bottom: var(--spacing-section-y)">
  <!-- or the Tailwind utility generated from the scale -->
  <section class="py-24">
</section>

<!-- Card internal padding uses a raw scale token -->
<div style="padding: var(--spacing-lg)">

<!-- Content container horizontal padding uses the semantic token -->
<div style="padding-left: var(--spacing-container-x); padding-right: var(--spacing-container-x)">

<!-- Hero content max-width uses the container token -->
<div style="max-width: var(--container-hero)">

<!-- Grid gap uses the card-gap semantic token or raw scale -->
<ul class="grid grid-cols-3" style="gap: var(--spacing-card-gap)">
```

### ❌ Don't

```astro
<!-- No arbitrary values for spacing in page templates -->
<section class="py-[96px]">
<div class="mt-[72px]">

<!-- No hand-tuned mixed-unit math -->
<div style="margin-top: 1.2rem">

<!-- No deriving spacing from pixel values that aren't on the scale -->
<div class="pt-[100px]">

<!-- No using raw max-w-* utilities for containers — use --container-* -->
<div class="max-w-[750px]">
```

---

## Accessibility & responsiveness

- **Horizontal page padding grows on larger viewports.** Mobile uses `--spacing-container-x` (24px), tablet+ uses `--spacing-container-x-lg` (48px). This is handled in the `<Container>` component (ships in #9) or manually with `md:px-12` until then.
- **Vertical section spacing does not grow fluidly.** A stepped 96px section break is the same at 320px and 1920px viewports. This is intentional — fluid vertical spacing interacts badly with fixed-height grid rows and leads to "shrinkage panic" on small viewports.
- **Touch targets**: interactive elements need minimum 24×24px CSS pixels per WCAG 2.2 SC 2.5.8. `--spacing-lg` (32px) comfortably exceeds this. Buttons and nav links should use at least `--spacing-lg` for their clickable area (`py-2` plus `text-caption` line-height gives ~28px, adequate; `py-3` gives ~36px, comfortable).
- **Reduced motion** is handled by the [motion spec](./motion.md) (#8), not here. Spacing doesn't animate.

---

## Strictness — absolute

Every margin, padding, and gap in a page template or component **must** use a `--spacing-*` or `--container-*` token (or a Tailwind utility generated from one). No `[arbitrary-value]` spacing. No raw pixel or rem values in inline styles. No exceptions in page files.

**Legitimate exception paths:**

1. **Off-scale one-offs become bespoke tokens.** The `--header-height: 72px` token is the template — if you need an off-scale value, make a new token with a clear name and document why in `global.css`. Reference it via `pt-[var(--header-height)]` when the value feeds into layout.
2. **Prose-level `em` spacing.** Inside `src/styles/prose.css`, spacing in `em` units is allowed because Markdown prose should scale with its font size. This is contained to that one file.
3. **Negative margins for overlap effects.** `-mt-24` for the article header card overlapping the hero is a legitimate layout trick. These are rare and should reference a scale value negated (`margin-top: calc(-1 * var(--spacing-3xl))`), not a raw pixel.
4. **Zero resets.** `p-0`, `m-0`, `gap-0` are allowed as explicit resets — they declare "no spacing" rather than picking a scale value, and are commonly needed to remove default `<ul>` / `<li>` padding and margins.
5. **Sub-scale typographic alignment.** Sub-pixel or 1–2px nudges for optical alignment of borders, underlines, or baselines are allowed as Tailwind arbitrary values (e.g. `pb-0.5` to nudge an underline down 2px for visual centering). These are typography fine-tuning, not layout spacing, and don't belong on the spacing scale. Keep them localized to single elements.

---

## Implementation pointers

| What | Where |
|---|---|
| Token definitions (`--spacing-*`, `--container-*`) | `src/styles/global.css` `@theme` block |
| Prose paragraph spacing (uses `--spacing-prose-paragraph` / `--spacing-rhythm`) | `src/styles/prose.css` |
| Layout primitives component (`<Container>`, `<Stack>`, etc.) | Ships in [layout primitives #9](./layout.md) |
| Tailwind utilities | Tokens prefixed with `--spacing-*` generate `p-*`, `gap-*`, `mt-*`, etc. utilities automatically via Tailwind 4's `@theme` system |

---

## What this spec doesn't cover

- **Layout primitives** (`Container`, `Stack`, `Cluster`, `Grid`) — see acts-of-defiance#9. Those are the components that consume these tokens.
- **Motion & transitions** — see acts-of-defiance#8.
- **Buttons & links** — see acts-of-defiance#10.

---

## Relationship to the design standards

This spec is referenced from `docs/specs/design-standards.md` under the sub-specs index. When adding a new component or page template that contains any spacing, this spec is the authority.
