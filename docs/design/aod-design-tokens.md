# Acts of Defiance — Design Tokens

Concrete design tokens extracted from the Stitch comps (v2). These are the values the Astro implementation should use. They reflect the abstract palette in `aod-visual-design.md` as actual hex values, with Stitch's Material Design-style tonal variations.

## Source

Generated from Stitch project `9403730584890634044`, screens V2 (home, article, category). HTML references available in `art/comps/v2/*.html`.

## Brand Palette (design source of truth)

These are the six core brand colors from the visual design language. All other tokens derive from or harmonize with these:

```css
--color-warm-gold: #D4A843;        /* Primary — hope, highlights, rays */
--color-revolutionary-red: #C23B22; /* Secondary — urgency, CTAs */
--color-movement-teal: #2A7B88;     /* Tertiary — interactive, links */
--color-deep-charcoal: #1A1A1A;     /* Dark backgrounds, text */
--color-parchment: #F5EDD6;         /* Light backgrounds, reading */
--color-earth-brown: #6B4226;       /* Borders, subtle warmth */
```

## Material Tonal Palette (Stitch-generated)

Stitch generates a full Material Design tonal palette from the seed colors. The Astro implementation can use these directly via Tailwind classes or adapt them.

### Primary (derived from revolutionary red #C23B22)

```css
--primary: #b7102a;
--primary-container: #db313f;
--on-primary: #ffffff;
--on-primary-container: #fffbff;
--primary-fixed: #ffdad8;
--primary-fixed-dim: #ffb3b1;
--on-primary-fixed: #410007;
--on-primary-fixed-variant: #92001c;
--inverse-primary: #ffb3b1;
--surface-tint: #bb152c;
```

### Secondary (derived from warm gold #D4A843)

```css
--secondary: #795900;
--secondary-container: #fece65;
--on-secondary: #ffffff;
--on-secondary-container: #755700;
--secondary-fixed: #ffdf9f;
--secondary-fixed-dim: #eec058;
--on-secondary-fixed: #261a00;
--on-secondary-fixed-variant: #5b4300;
```

### Tertiary (derived from movement teal #2A7B88)

```css
--tertiary: #026672;
--tertiary-container: #2f7f8c;
--on-tertiary: #ffffff;
--on-tertiary-container: #f7feff;
--tertiary-fixed: #a3eefd;
--tertiary-fixed-dim: #87d2e0;
--on-tertiary-fixed: #001f24;
--on-tertiary-fixed-variant: #004e59;
```

### Surface & Background

```css
--background: #fcf9f8;
--on-background: #1c1b1b;
--surface: #fcf9f8;
--on-surface: #1c1b1b;
--surface-variant: #e5e2e1;
--on-surface-variant: #5b403f;
--surface-dim: #dcd9d9;
--surface-bright: #fcf9f8;
--surface-container-lowest: #ffffff;
--surface-container-low: #f6f3f2;
--surface-container: #f0eded;
--surface-container-high: #eae7e7;
--surface-container-highest: #e5e2e1;
--inverse-surface: #313030;
--inverse-on-surface: #f3f0ef;
```

### Outline & Error

```css
--outline: #8f6f6e;
--outline-variant: #e4bebc;
--error: #ba1a1a;
--error-container: #ffdad6;
--on-error: #ffffff;
--on-error-container: #93000a;
```

## Typography

```css
--font-headline: "Montserrat", "Epilogue", sans-serif;  /* Bold condensed, protest signage */
--font-body: "Inter", sans-serif;                        /* Clean geometric, readable */
--font-label: "Newsreader", serif;                       /* Slab-adjacent, editorial weight */
```

### Font weights

- Headline: 700, 800, 900 (bold to black)
- Body: 400, 500, 600 (regular to semi-bold)
- Label: 400, 600 (regular to semi-bold)

### Google Fonts import

```html
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700;800;900&family=Inter:wght@400;500;600&family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,600;1,6..72,400&display=swap" rel="stylesheet">
```

## Border Radius

```css
--radius-default: 0.125rem;  /* 2px — subtle */
--radius-lg: 0.25rem;        /* 4px */
--radius-xl: 0.5rem;         /* 8px */
--radius-full: 0.75rem;      /* 12px — rounded cards */
```

## Custom Gradients & Effects

### Sunburst background effect
```css
.sunburst-bg {
  background: radial-gradient(circle at center, rgba(212, 168, 67, 0.15) 0%, transparent 70%);
}
```

### Hero gradient overlay
```css
.hero-gradient {
  background: linear-gradient(
    to top,
    rgba(26, 26, 26, 0.95) 0%,
    rgba(26, 26, 26, 0.4) 50%,
    transparent 100%
  );
}
```

### Parchment texture
A subtle paper texture background is applied to reading areas. Use a texture image or a CSS-generated noise pattern.

## Component Tokens

### Header
- Background: `#1A1A1A` with `backdrop-blur-md bg-opacity-85`
- Logo mark color: `#D4A843`
- Logo text: `#D4A843`, Montserrat 900, uppercase, tracking-tighter
- Nav links: white, hover → `#D4A843`
- Nav link font: Montserrat medium, uppercase, small tracking

### Footer
- Background: `#1A1A1A`
- Tagline: `#D4A843`, Newsreader italic
- Tagline text: "Remembering those whose very existence defied injustice."

### Category chips
- Artists: gold (`#D4A843`)
- Movements: revolutionary red (`#C23B22`)
- Organizations: teal (`#2A7B88`)
- People: earth brown (`#6B4226`)
- Typography: Montserrat bold, uppercase, tracking-widest, tiny size

### Article cards
- Aspect ratio: 4/5 for card image area
- Shadow: `shadow-xl` on image
- Hover: image scales 110%, headline shifts to primary color
- Border-radius: `rounded-lg` (4px)

### Pull quotes
- Left border: 4px solid `#D4A843`
- Font: Newsreader italic
- Larger size than body

## Notes for Astro Implementation

1. **Tailwind config** — the full Tailwind theme extension is in `art/comps/v2/home.html` lines ~15-75. Can be copied directly into `tailwind.config.mjs`.
2. **Stitch vs Brand palette** — Stitch generated a Material tonal system from our seed colors. The brand palette (warm gold, revolutionary red, etc.) is authoritative; the tonal variants are convenient semantic aliases.
3. **Dark mode** — the Tailwind config uses `darkMode: "class"`. We should decide whether Acts of Defiance supports dark mode. The current design already has dark header/footer with light reading areas.
4. **Sample markup** — all three HTML comps in `art/comps/v2/` provide working reference implementations for header, footer, hero, cards, tabs, and related components.
