# Acts of Defiance — Visual Design Language

## Art Direction

**Core aesthetic:** Revolutionary movement poster art — modernized with hope. Inspired by propaganda posters, WPA murals, union graphics, and liberation movement art, but without the grimness. The visual message is: *these struggles gave us something worth celebrating.*

**Illustration style:**
- Bold graphic illustration, not photography (photography may be used editorially but illustration is the brand voice)
- Thick outlines, flat color fields with subtle texture (screen-print/woodcut feel)
- Strong central figures, crowd compositions, radiating energy lines
- Sunburst/ray motifs as a recurring visual element

**Reference art:** See `/art/` directory — Frantz Fanon, Catholic Worker, Diego Rivera, IWW, ACLU pieces establish the visual vocabulary.

### Art direction for Imagen 3

When generating article art, prompts should reference: "bold graphic illustration in the style of revolutionary movement poster art, strong outlines, flat color fields, warm palette, radiating composition, hopeful tone, modern sensibility."

Incorporate the colors, logos, symbols, and visual language specific to the subject — a piece about the IWW should weave in their red and black palette and globe-and-stars iconography; a piece about the Catholic Worker movement should draw from their own visual tradition. Bring each entity's aesthetic into the Acts of Defiance illustration style rather than applying a generic treatment.

Always verify that incorporated logos and imagery are not under active copyright protection before generation.

### What this is not

- Not photorealistic
- Not watercolor or painterly
- Not minimalist or flat design
- Not stock illustration
- Not dark or grim — even heavy subjects get a hopeful visual treatment

## Color Palette

Derived from the existing art assets. The palette should feel warm overall — golds and reds dominate, teal provides contrast, parchment keeps it from being heavy.

| Role | Name | Hex | Usage |
|---|---|---|---|
| Primary | Warm Gold | `#D4A843` | Radiating rays, highlights, hope |
| Secondary | Revolutionary Red | `#C23B22` | Accents, CTAs, urgency |
| Tertiary | Movement Teal | `#2A7B88` | Links, secondary accents, coolness |
| Dark | Deep Charcoal | `#1A1A1A` | Text, dark backgrounds |
| Light | Parchment | `#F5EDD6` | Backgrounds, breathing room |
| Accent | Earth Brown | `#6B4226` | Borders, subtle warmth |

### Usage guidelines

- **Dark backgrounds** for featured/hero sections — creates cinematic weight
- **Parchment backgrounds** for reading areas — warm, easy on the eyes, invokes paper
- **Gold** is the signature color — use for highlights, dividers, the feeling of hope
- **Red** sparingly for calls to action and emphasis — it's the most aggressive color in the palette
- **Teal** for interactive elements (links, hover states) — provides necessary contrast against the warm palette
- Ensure all color combinations meet WCAG 2.2 AA contrast requirements

## Typography

Layered typographic system — three voices working together:

| Role | Style | Candidates | Feel |
|---|---|---|---|
| Headlines | Bold condensed sans-serif | Oswald, Barlow Condensed | Protest signage, urgent, punchy |
| Body | Clean geometric sans-serif | Inter, Source Sans 3 | Readable, modern, accessible |
| Accents/labels | Slab serif | Roboto Slab, Zilla Slab | Editorial weight, bridges old and new |

### Typography rules

- Headlines are uppercase-capable but not always uppercase — use caps for short declarative statements ("DEFIANCE IS HOPE"), mixed case for longer titles ("The Movement That Changed Everything")
- Body text minimum 18px for readability (per design standards — WCAG 2.2 AA)
- Line-height 1.6+ for long-form reading
- Maximum line length ~70 characters for comfortable reading
- All fonts must be available as variable fonts or have sufficient weight range (400, 600, 700 minimum)
- Load fonts with `font-display: swap` for performance

## Component Patterns

### Article cards
- Illustration-forward — large image area, headline overlaid or immediately below
- Category tag as colored chip (color per category)
- No date clutter on cards — date lives on the article page
- Hover: subtle lift/shadow, not color change

### Category tiles
- Bold colored background per category
- Iconic illustration specific to each category (not generic icons)
- Text layered in HTML, never baked into the image
- Per GitHub issue #1: rounded corners, hover effects (background deepens, icon pulses subtly)

### Featured article (home hero)
- Full-width hero illustration
- Headline in condensed type over dark overlay or adjacent panel
- Should feel like a magazine cover — one story, commanding attention

### Pull quotes
- Slab serif, larger size
- Gold left-border accent
- Used for impactful quotes within articles — movement leaders, historical speeches

### Tags
- Small, muted, pill-shaped
- Functional, not decorative — they help navigation, they don't demand attention
- Consistent color (muted teal or charcoal outline)

## Imagery Rules

- Article hero images are always illustrations, generated via Imagen 3 with the art direction above
- Thumbnails/cards crop from the hero — no separate thumbnail generation
- No stock photography for article art
- Photography is acceptable for documentary/archival content within articles (historical photos with proper attribution)
- All images must have meaningful alt text (WCAG 2.2 AA requirement)
- Images optimized via Astro's built-in image optimization (responsive sizing, modern formats)
