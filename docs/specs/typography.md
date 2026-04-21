# Typography System

The typographic foundation for Acts of Defiance. This is the spec — the code in `src/styles/global.css`, `src/styles/prose.css`, `src/components/SectionHead.astro`, and `src/components/Prose.astro` is the implementation.

**Status:** v1, established by acts-of-defiance#6.
**Sibling specs:** spacing & vertical rhythm (#7), motion (#8), layout primitives (#9), buttons & links (#10).

---

## Foundations

### Modular scale

The type scale is **Augmented Fourth (ratio √2 ≈ 1.4142)**. Every step is derivable from the base by `base × ratio^n`. Sizes are not invented per-step — pick a step or pick a different ratio, but don't introduce one-off values.

Why Augmented Fourth and not Perfect Fourth (1.333)? Acts of Defiance is an editorial publication with a cinematic, declamatory voice ("DEFIANCE IS AN ACT OF HOPE.", "PEOPLE", "MOVEMENTS"). The gentler Perfect Fourth flattens the top of the scale; Augmented Fourth gives the dramatic display sizes the brand is built on.

### Base font size

- **Min base:** 16px (at viewport 320px)
- **Max base:** 18px (at viewport 1440px)

Body text scales fluidly between these values. WCAG 2.2 AA requires body text at minimum 16px — at no point does any body-sized text drop below this floor.

### Fluid type via `clamp()`

**No breakpoint stacks.** Each step is a single `clamp(min, vw-based, max)` value. The pre-system pattern of `text-5xl md:text-7xl lg:text-8xl` produced four undocumented hero sizes — that pattern is banned.

The fluid range is **320px → 1440px**. Below 320px the size pins to its min; above 1440px it pins to its max. The site is comfortable up to 1920px without further scaling.

Reference for the math: [utopia.fyi](https://utopia.fyi).

### Spacing dependency

Type and spacing are coupled. The leading values defined here are the input the spacing system (#7) will derive vertical rhythm from. Don't change leading values in this spec without checking with the spacing ticket.

---

## The scale

The system is split into two clamp philosophies:

- **Body steps** (caption, body, body-lg) use *modest* clamps where both min and max sit on the modular scale. Body text wraps naturally and doesn't have a hard width constraint.
- **Heading steps** (h4, h3, h2, h1, display) use *aggressive* clamps where the **max stays on the modular scale** but the **min is sized empirically to fit headline text at 320px viewport without horizontal overflow**. The modular scale governs the max; the narrow-viewport constraint governs the min. This is the only practical way to combine dramatic display sizes with a single fluid value.

| Token | Step | Min (px) | Max (px) | `clamp()` value | Purpose |
|---|---|---|---|---|---|
| `--text-caption` | -1 | 11 | 13 | `clamp(0.688rem, 0.625rem + 0.313vw, 0.813rem)` | Tiny labels: category chips, date stamps, tags, nav links, button labels |
| `--text-body` | 0 | 16 | 18 | `clamp(1rem, 0.964rem + 0.179vw, 1.125rem)` | Default paragraph |
| `--text-body-lg` | +1 | 23 | 25 | `clamp(1.438rem, 1.371rem + 0.179vw, 1.563rem)` | Lead paragraph (article first-child), hero subheads, taglines |
| `--text-h4` | +2 | 24 | 36 | `clamp(1.5rem, calc(1.286rem + 1.071vw), 2.25rem)` | Article card titles, related card titles, prose H2 in body |
| `--text-h3` | +3 | 28 | 51 | `clamp(1.75rem, calc(1.339rem + 2.054vw), 3.188rem)` | Reserved for sub-section heads (not currently used) |
| `--text-h2` | +4 | 32 | 72 | `clamp(2rem, calc(1.286rem + 3.571vw), 4.5rem)` | Section heads (`SectionHead` component) |
| `--text-h1` | +5 | 32 | 102 | `clamp(2rem, calc(0.75rem + 6.25vw), 6.375rem)` | Article and about page titles |
| `--text-display` | +6 | 28 | 144 | `clamp(1.75rem, calc(-0.321rem + 10.357vw), 9rem)` | Hero display headlines (home hero — though prefer `--text-h1` if the text wraps multi-line — and category page hero like "ORGANIZATIONS"). |

### Modular scale relationship

The **maxes** form a strict Augmented Fourth progression: `18 × √2 ≈ 25 → 36 → 51 → 72 → 102 → 144`. Verify with `previous_max × 1.4142`.

The **mins** for headings are *not* on the scale — they are sized to fit the longest expected headline word at 320px viewport (272px usable after `px-6` margins) at the typical Montserrat 900 character width of ~0.675 em/char. Keeping the mins on the scale would force horizontal overflow on small phones, which the design will not tolerate. This trade-off is documented and intentional.

### Narrow-viewport headline rule of thumb

A heading at font-size F can fit a word of N characters in a container of W px when `N × 0.675 × F ≤ W`. At 320px viewport with `px-6` margins (W ≈ 272), the constraint is **F ≤ 272 / (N × 0.675)**:

| Longest word (chars) | Max font-size at 320px |
|---|---|
| 8 ("DEFIANCE") | ~50px |
| 11 ("PSYCHIATRIST") | ~37px |
| 13 ("ORGANIZATIONS") | ~31px |

Choose the right token based on the longest word your headline will contain. If unsure, use `--text-h1` for multi-line wrapping headlines and `--text-display` only for short, dramatic single-word category-style headers.

### Off-scale text

The only sanctioned off-scale text is the **brand mark** — `ACTS OF DEFIANCE` in the site header — fixed at 20px. It's a logotype, not body text. Don't apply this exception elsewhere.

---

## Heading character

The scale defines size only. Each step also has default character (font, weight, line-height, letter-spacing) baked into the global CSS.

| Token | Family | Weight | Line-height | Letter-spacing | Style |
|---|---|---|---|---|---|
| `--text-display` | Montserrat | 900 (black) | 0.9 | -0.025em | uppercase |
| `--text-h1` | Montserrat | 900 | 1.0 | -0.025em | uppercase |
| `--text-h2` | (variant-dependent — see SectionHead) | | | | |
| `--text-h3` | Montserrat | 900 | 1.05 | -0.025em | uppercase |
| `--text-h4` | Montserrat | 900 | 1.05 | -0.025em | uppercase |
| `--text-body-lg` | Inter | 400 | 1.5 | 0 | normal |
| `--text-body` | Inter | 400 | 1.6 | 0 | normal |
| `--text-caption` | Montserrat | 700 (bold) | 1.4 | 0.1em (tracked out) | uppercase |

**Why caption is uppercase + tracked:** the scale step is small (11–13px), but the visual weight from uppercase + bold + tracking-out gives it presence as a UI label. This is what makes nav links readable at this size despite being smaller than typical 14px nav text.

---

## H2 / Section heads — the two variants

Section heads have **two variants** at the same size (`--text-h2`). Use the `SectionHead` component, never an inline `<h2>`. The component enforces the rule.

### `editorial`

- **Family:** Newsreader serif
- **Weight:** 400
- **Style:** italic
- **Letter-spacing:** 0
- **Case:** mixed (sentence case)

**When to use:** introducing a list of editorial content. The voice is the publication speaking — soft, declarative, like a magazine subhead.

Examples:
- Home page "Recent stories" (introducing the article grid)
- About page "What we cover" (introducing the category tiles)
- Article page "Go deeper" (introducing the resources grid — when implemented)

### `structural`

- **Family:** Montserrat
- **Weight:** 900 (black)
- **Style:** normal
- **Letter-spacing:** -0.025em
- **Case:** uppercase

**When to use:** closing a page with related content or a CTA. The voice is the publication structure speaking — bold, declarative, terminal.

Examples:
- Article page "More acts of defiance" (related articles at end of page)
- Newsletter CTA "Join the Defiance" (when implemented)

### Usage

```astro
<SectionHead variant="editorial">Recent stories</SectionHead>
<SectionHead variant="structural">More acts of defiance</SectionHead>
```

### How to decide

If you're introducing a list of content the publication is presenting → editorial. If you're closing a page with a CTA or related-content block → structural. If you're not sure: it's editorial. Default to the softer voice; reserve structural for emphasis.

---

## Prose

Markdown bodies (article content, manifesto content, anything from the `Content` collection render) use the `Prose` component, which provides a single canonical set of prose styles defined in `src/styles/prose.css`.

```astro
<Prose>
  <Content />
</Prose>
```

Available props: `class` (extension classes for layout/positioning). The reading measure (`max-w-reading`, 700px) is baked into the component — no `maxWidth` prop needed.

### Prose contract

Inside `.prose`:

| Element | Token | Notes |
|---|---|---|
| `p` | `--text-body` | line-height 1.75 for readable long-form |
| `p:first-child` | `--text-body-lg` | lead paragraph treatment |
| `h2` | `--text-h4` | amber accent color, uppercase, 2.5em top margin |
| `h3` | `--text-body-lg` | amber accent color, uppercase |
| `blockquote p` | `--text-h4` | italic Newsreader, amber, with `border-left: 4px solid #d4a843` |
| `blockquote cite` | `--text-caption` | Montserrat, uppercase, tracked |
| `em` | inherit | italic |
| `strong` | inherit | weight 700 |
| `a` | inherit | amber, underlined |
| `ul`, `ol` | `--text-body` | line-height 1.75 |
| `code` | inherit | monospace, subtle background |

If you find yourself writing `<style>` blocks on a page to override prose, **stop**. Add the override to `src/styles/prose.css` so every page benefits, or extend the `Prose` component with a new variant prop.

---

## Labels — chips, badges, micro-UI

All UI labels (category chips, tags, dates, button text, nav links) use `--text-caption` with `uppercase`, `font-weight: 700`, and `letter-spacing: 0.1em` (or tighter for tags). This creates a consistent label voice across the site.

The only exception is the brand mark (logotype), which is 20px and not part of the scale.

---

## Usage rules — do this, not that

### ✅ Do

```astro
<h1 style="font-size: var(--text-display); line-height: 0.9">Defiance is an act of hope.</h1>
<SectionHead variant="editorial">Recent stories</SectionHead>
<Prose><Content /></Prose>
<span style="font-size: var(--text-caption)" class="font-bold uppercase tracking-widest">Movements</span>
```

### ❌ Don't

```astro
<!-- No hand-tuned breakpoint stacks -->
<h1 class="text-5xl md:text-7xl lg:text-8xl font-black">...</h1>

<!-- No inline h2 — use SectionHead -->
<h2 class="text-4xl italic font-label">Recent stories</h2>

<!-- No page-level scoped prose CSS — use Prose component -->
<style>
  .article-body :global(p) { font-size: 1.125rem; }
</style>

<!-- No hardcoded sizes on labels — use --text-caption -->
<span class="text-[10px]">Movements</span>
```

---

## Accessibility — WCAG 2.2 AA

- Body text is **16px or larger** at the minimum viewport. The fluid scale does not drop below the 16px floor for body text.
- Body line-height is **1.6** for default body and **1.75** for prose body. Both exceed the 1.5 minimum.
- Letter-spacing on uppercase tracked labels (0.1em) does not exceed the 0.12em maximum for AAA, comfortably under the AA threshold.
- All text colors used in the system pass **4.5:1 contrast** for normal text and **3:1 for large text** against their backgrounds. The primary high-contrast pair is `#1c1b1b` on `#fcf9f8` (≈14.7:1) which exceeds AAA.
- The scale supports user zoom up to 200% without breaking layout. Fluid `clamp()` values are tested at 320px (~iPhone SE), 768px (tablet), 1440px (desktop), and 1920px (wide) viewports.

---

## Implementation pointers

| What | Where |
|---|---|
| Token definitions (`--text-*`) | `src/styles/global.css` `@theme` block |
| Default heading character (h1–h6 family/weight/leading) | `src/styles/global.css` |
| Prose styles | `src/styles/prose.css` |
| `SectionHead` component | `src/components/SectionHead.astro` |
| `Prose` component | `src/components/Prose.astro` |
| Tailwind utility usage | tokens generate `text-caption`, `text-body`, etc. via `@theme` |

---

## What this spec doesn't cover

- **Spacing & vertical rhythm** — see acts-of-defiance#7
- **Motion** — see acts-of-defiance#8
- **Layout primitives (Container, Stack, Cluster, Grid)** — see acts-of-defiance#9
- **Buttons & links** — see acts-of-defiance#10
