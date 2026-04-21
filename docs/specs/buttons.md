# Buttons & Links

Single `<Button>` component for all CTAs and interactive elements across Acts of Defiance.

**Status:** v1, established by acts-of-defiance#10.
**Depends on:** [typography](./typography.md), [motion](./motion.md), [spacing](./spacing.md).

---

## Component

`src/components/Button.astro`

Renders `<a>` when `href` is provided, `<button>` otherwise. Semantics follow the element's purpose — navigation uses `<a>`, actions use `<button>`.

```astro
import Button from "../components/Button.astro";

<Button href="/about">Read the Manifesto</Button>
<Button variant="secondary" size="sm">Subscribe</Button>
<Button variant="ghost" type="button">Cancel</Button>
<Button variant="link" href="/categories/artists">Artists</Button>
```

### Props

| Prop | Type | Default | Description |
|---|---|---|---|
| `variant` | `"primary" \| "secondary" \| "ghost" \| "link"` | `"primary"` | Visual style |
| `size` | `"sm" \| "md" \| "lg"` | `"md"` | Padding + font size |
| `href` | `string?` | — | Renders `<a>` when present |
| `disabled` | `boolean` | `false` | Disabled state |
| `class` | `string` | `""` | Extra classes |

All other attributes pass through to the rendered element (`type`, `aria-*`, `data-*`, etc.).

---

## Variants

### primary
Revolutionary red background, white text. The dominant CTA — use once per page section at most.

```astro
<Button href="/about">Read the Manifesto</Button>
<Button>Publish article</Button>
```

**Colors:** `bg-revolutionary-red` / `color: white`
**Motion:** `aod-brand-btn` letterpress press + `aod-focus-ring` pulse

### secondary
Warm gold background, deep-charcoal text. For secondary actions alongside a primary CTA.

```astro
<Button variant="secondary">Save draft</Button>
```

**Colors:** `bg-warm-gold` / `color: deep-charcoal`
**Motion:** `aod-brand-btn` letterpress press + `aod-focus-ring` pulse

### ghost
Transparent with deep-charcoal border. For tertiary or destructive actions.

```astro
<Button variant="ghost" type="button">Cancel</Button>
<Button variant="ghost" type="button">Delete</Button>
```

**Colors:** transparent bg / `color: deep-charcoal` / `border: 2px solid deep-charcoal`
**Motion:** adapted letterpress (border-colored plate) + `aod-focus-ring` pulse

### link
Text-only. For inline links in prose and navigational contexts where no button chrome is wanted. Uses `aod-brand-link` (warm-gold underline sweep) instead of letterpress.

```astro
<Button variant="link" href="/categories/artists">Artists</Button>
```

**Motion:** `aod-brand-link` underline sweep + `aod-focus-ring` pulse

**Note:** Nav links in the header and footer are plain `<a>` elements with `aod-brand-link aod-focus-ring` applied directly — they are not CTAs and do not use `<Button>`. Use `<Button variant="link">` for inline prose links and standalone text-link CTAs only.

---

## Sizes

Sizes are token-based — no raw px or Tailwind numeric spacing.

| Size | Padding | Font |
|---|---|---|
| `sm` | `px-sm py-3xs` | `--text-caption` |
| `md` (default) | `px-lg py-sm` | `--text-caption` |
| `lg` | `px-xl py-md` | `--text-body` |

All sizes use `font-family: var(--font-headline)`, `font-weight: 900`, `text-transform: uppercase`, `letter-spacing: widest`.

---

## States

All non-link variants share the same state pattern:

| State | Effect |
|---|---|
| `:hover` | Darkened background (15% toward black) via `color-mix` |
| `:focus` | `aod-focus-ring` — warm-gold outline + expanding pulse |
| `:active` | `aod-brand-btn` — 2px press-down + scale(0.98) + plate collapse |
| `disabled` | `pointer-events: none`; CSS variant rules handle visual dimming via `color-mix()` desaturation on `:disabled` and `[aria-disabled="true"]` |

The `link` variant uses `:hover` → underline sweep (warm-gold scale-x from 0→1) instead of background darkening.

---

## Motion notes

- Hover: `--duration-quick` (180ms) `--ease-manifesto`
- Press (`:active`): `--duration-snap` (90ms) `--ease-stamp`, releases at `--duration-quick` `--ease-manifesto`
- Focus pulse: `--duration-declare` (560ms) `--ease-stamp`, fires once
- All collapse to `0.01ms` under `prefers-reduced-motion: reduce`

---

## Accessibility

- `<a>` vs `<button>` semantics are enforced by the component — never render a `<button>` as a link or vice versa via role overrides.
- `<button>` elements default to `type="button"` to prevent accidental form submission when placed inside a `<form>`. Override with `type="submit"` when needed.
- Focus ring meets AA contrast (warm-gold on all variant backgrounds exceeds 3:1 for the 2px outline).
- `disabled` on `<a>` elements uses `aria-disabled="true"` + `tabindex="-1"` (removes from tab order; HTML `disabled` is not valid on anchors).
- Touch target minimum 24×24px is met by all sizes.

---

## Forbidden patterns

```astro
<!-- No raw anchor CTAs in page templates -->
<a href="/about" class="bg-primary text-white px-lg py-sm ...">CTA</a>

<!-- No inline button styling -->
<button class="bg-revolutionary-red rounded-lg ...">Action</button>
```

Use `<Button>` for all CTAs. The `aod-brand-link` + `aod-focus-ring` pattern is reserved for nav links (header, footer) where a full button component would be semantic overkill.

---

## Relationship to the design standards

This spec is referenced from `docs/specs/design-standards.md` under the sub-specs index. Button variants consume tokens from [spacing.md](./spacing.md), [typography.md](./typography.md), and [motion.md](./motion.md).
