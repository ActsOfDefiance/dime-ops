# Motion

The motion language for Acts of Defiance. This is the spec — the tokens and helper classes in `src/styles/global.css` are the implementation.

**Status:** v1, established by acts-of-defiance#8.
**Depends on:** [typography](./typography.md) (#6), [spacing](./spacing.md) (#7).
**Enables:** [layout primitives](./layout.md) (#9), [buttons & links](./buttons.md) (#10).

---

## Foundations

### Voice → motion

Acts of Defiance is an editorial publication about people, movements, and organizations that defied injustice. The voice is confident, declarative, and analog — manifestos, protest posters, risograph prints, letterpress type. The motion language should feel:

- **Stamped, not eased.** Arrivals are declarative, not hesitant.
- **Printed, not digital.** Think letterpress impact and risograph misregistration, not Material Design ripples.
- **Confident, not playful.** No springs. No bounces. At most one firm overshoot.
- **Hand-tuned, not defaulted.** Durations are intentionally off-grid and easings are custom curves, not `ease-in-out`.

No Tailwind defaults. No `duration-500 ease-linear`. Every moving pixel on the site goes through one of the tokens below.

### Stepped durations + brand-named easings

Durations are a **fixed 4-step scale** (90 / 180 / 320 / 560 ms). They're deliberately odd numbers — 180 is not 200, 320 is not 300, 560 is not 500. The off-grid values make the motion feel hand-set.

Easings are **four brand-named cubic-bezier curves** that each map to a specific interaction intent. The names carry meaning and the choice of curve is prescriptive per pattern.

---

## Tokens

### Durations

| Token | ms | Use |
|---|---|---|
| `--duration-snap` | 90 | Press/active feedback (button down-state). The fastest perceptible transition — anything faster feels instant. |
| `--duration-quick` | 180 | Color swaps, opacity fades, small background shifts. The default for "a small state change just happened." |
| `--duration-arrive` | 320 | Transform-based hovers: card lift, badge stamp-in, sweeping underline. Feels deliberate without dragging. |
| `--duration-declare` | 560 | Big reveals: image zoom on card hover, focus pulse, headline arrivals. Takes its time on purpose. |

### Easings

| Token | cubic-bezier | Character | Use |
|---|---|---|---|
| `--ease-stamp` | `(0.9, 0, 0.1, 1)` | Abrupt edges, fast middle — like a rubber stamp hitting paper | Press feedback, release-from-active, focus pulse expansion |
| `--ease-manifesto` | `(0.16, 1, 0.3, 1)` | Expo-out. Snaps in, decelerates long and deliberate | **Default** for hovers, lifts, color swaps, underline sweeps, card transitions |
| `--ease-ink` | `(0.77, 0, 0.175, 1)` | Symmetric steep — ink soaking in and drying | Reversible states, overlays, toggles, blur filters |
| `--ease-defiant` | `(0.32, 1.12, 0.28, 1)` | One firm push past the target, then settles. Overshoot is 1.12 — noticeable but not bouncy | Sparingly — badge stamp-in, single arrival moments |

**Default easing is `--ease-manifesto`.** If you're not sure which easing to use, use manifesto. The other three are for specific named intents.

### Pattern × token matrix

| Interaction | Property | Duration | Easing |
|---|---|---|---|
| Link color + underline sweep | `color`, `transform` | `quick` + `arrive` | `manifesto` |
| Button hover (bg swap) | `background-color` | `quick` | `manifesto` |
| Button active (press) | `transform`, `box-shadow` | `snap` | `stamp` |
| Card hover (lift + shadow) | `transform`, `box-shadow` | `arrive` | `manifesto` |
| Card image zoom | `transform` | `declare` | `manifesto` |
| Card headline riso offset | `transform`, `text-shadow` | `quick` | `manifesto` |
| Badge stamp-in (arrival) | `transform`, `opacity` | `arrive` | `defiant` |
| Focus ring outline | *(none)* | — | — (instant) |
| Focus ring pulse | `box-shadow` | `declare` | `stamp` |
| Nav link color shift | `color` | `quick` | `manifesto` |

---

## Interaction patterns

### Links — sweeping underline

```html
<a href="/..." class="aod-brand-link">Text</a>
```

Hover / focus: text color swaps to `--color-warm-gold` (`--duration-quick`) and a 2px warm-gold underline sweeps in from left via `transform: scaleX(0 → 1)` with `transform-origin: left center` (`--duration-arrive`).

This replaces the bare `transition-colors hover:text-warm-gold` pattern everywhere it appears.

### Buttons — letterpress press

```html
<button class="aod-brand-btn bg-revolutionary-red text-white ...">Text</button>
```

The `.aod-brand-btn` helper class adds:
- **Rest state:** `box-shadow: 0 2px 0 0 var(--color-deep-charcoal)` — a 2px deep-charcoal bar underneath the button that reads as a press plate.
- **`:active`:** button translates `translateY(2px) scale(0.98)` + the press plate collapses to 0. `--duration-snap` `--ease-stamp`. Feels like pressing a letterpress key down.
- **`:hover`:** the bg color shift is provided by the component itself (Tailwind utilities like `hover:bg-[color]`), not the helper.

### Cards — risograph headline offset (hover only)

```html
<a class="aod-brand-card group block ...">
  <div class="aspect-[4/3] overflow-hidden">
    <img class="aod-brand-card__image" ... />
  </div>
  <div>
    <h3 class="aod-brand-card__title">Headline</h3>
  </div>
</a>
```

Three layered effects:

1. **Card body:** `translateY(-4px)` lift + shadow `--duration-arrive` `--ease-manifesto`.
2. **Image (`.aod-brand-card__image`):** `scale(1.04)` zoom `--duration-declare` `--ease-manifesto`.
3. **Headline (`.aod-brand-card__title`):** `translate(2px, 0)` + `text-shadow: -2px 2px 0 var(--color-revolutionary-red)` — this is the risograph misregistration effect. **Hover-only** (not a static decoration), `--duration-quick` `--ease-manifesto`.

The three durations stagger: headline shifts first (`quick`), card lifts (`arrive`), image zooms slowest (`declare`). This intentional layering gives the hover state a sense of depth.

### Badges — stamp-in arrival

```html
<span class="motion-stamp-in" style="background: ...">Category</span>
```

On initial paint (or when the element is re-inserted into the DOM), the badge scales from `0.94 → 1` with opacity `0 → 1` over `--duration-arrive` with `--ease-defiant`. The single overshoot at 1.12 on the easing curve gives it the feel of being pressed onto the page.

**Use sparingly.** Stamping every chip on an article feed would feel frantic. Appropriate for: the hero badge on the home page, the category pill on an article page, the badges that appear after filter changes.

### Focus ring — outward pulse

```html
<button class="aod-focus-ring ...">...</button>
```

Any element with `.aod-focus-ring` gets:
- **Instant outline** (2px solid `--color-warm-gold`, offset 4px). Fires on any `:focus`, including pointer clicks — this is a brand decision (see below).
- **1-shot outward pulse** via `box-shadow` animating from `6px → 24px` spread with `rgba(warm-gold, 0.9 → 0)`. `--duration-declare` `--ease-stamp`. The pulse starts at the outer edge of the outline so it's visible *beyond* the ring, not hidden underneath it.

**Brand decision: pulse fires on `:focus`, not `:focus-visible`.** The standard accessibility convention is that mouse clicks should not paint focus rings, but for this site the focus indicator is a first-class brand moment. We want the user to feel the button push back. The outline itself remains WCAG 2.2 AA compliant (3:1 warm-gold-on-charcoal, 4.5:1 warm-gold-on-surface), which is the accessibility guarantee that matters.

### Nav links (header + footer)

Use `.aod-brand-link` for all nav items. The active state (current page) is a static warm-gold color + permanent warm-gold underline (no sweep, no transition), so active pages read as "already arrived."

---

## Reduced motion

A global `@media (prefers-reduced-motion: reduce)` rule in `global.css` forces every animation and transition to `0.01ms !important`. Scroll-behavior collapses to `auto`.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

**What still happens with reduced motion on:**
- Hover states still toggle (the end state is visible, it just snaps instead of easing).
- The risograph headline offset snaps to its end state on hover.
- Focus outlines still appear; the pulse is effectively a flash.
- Badge stamp-in snaps to its final scale without the overshoot.

**What does not happen:**
- No sweeping underlines — the underline appears/disappears instantly.
- No card lifts — the shadow just toggles.
- No image zoom — the image stays at 1× on hover.

**Why `0.01ms` and not `0ms`:** zero-duration transitions don't fire `transitionend` in Safari, which breaks code that relies on the event. One hundredth of a millisecond is imperceptible but event-safe.

**Verifying in DevTools:** Chrome → Rendering panel → "Emulate CSS media feature prefers-reduced-motion" → reduce. Firefox → about:config → `ui.prefersReducedMotion` = 1.

---

## Usage rules — do this, not that

### ✅ Do

```astro
<!-- Use the helper classes for brand-coded interactions -->
<a href="/about" class="aod-brand-link">About</a>
<button class="aod-brand-btn aod-focus-ring bg-revolutionary-red">Read</button>
<a class="aod-brand-card group block" href="/article">
  <img class="aod-brand-card__image" ... />
  <h3 class="aod-brand-card__title">Headline</h3>
</a>

<!-- Ad-hoc transitions reference the tokens directly -->
<div style="transition: opacity var(--duration-quick) var(--ease-manifesto)">
```

### ❌ Don't

```astro
<!-- No Tailwind default transitions -->
<a class="transition-colors hover:text-warm-gold">
<div class="transition-all duration-300 ease-in-out">

<!-- No hardcoded ms/cubic-bezier values -->
<div style="transition: transform 200ms ease">

<!-- No transition-all — always name the properties -->
<button class="transition-all hover:scale-105">

<!-- No ::after underline duplication — use .aod-brand-link -->
<a class="relative hover:after:scale-x-100">
```

### Exception paths

1. **`transition-none`** — explicitly disabling transition on an element that would otherwise inherit one is allowed.
2. **SVG attribute animation** — when animating SVG `path` data or attributes that CSS transitions can't reach, `<animate>` or JS with explicit token references is allowed.
3. **Scroll-linked animations** — for scroll-driven effects (e.g. header shrink on scroll), JS reads the tokens from `getComputedStyle(document.documentElement)` and uses them directly. No literal duration values in JS.
4. **Third-party components** — if a future embedded widget (e.g. a video player) brings its own transitions, don't fight them. Override only if they conflict with brand motion on surrounding elements.

---

## Accessibility

- **Focus indicator contrast:** warm-gold `#d4a843` against the two primary surfaces — 3.1:1 on deep-charcoal, 4.9:1 on parchment — meets WCAG 2.2 SC 1.4.11 (non-text contrast, 3:1 minimum).
- **Touch targets:** motion is applied *on top of* spacing; this spec doesn't change minimum sizes. See [spacing.md](./spacing.md) §accessibility.
- **Reduced motion:** see §reduced-motion above. WCAG 2.2 SC 2.3.3 (animation from interactions) is met.
- **Vestibular safety:** no full-page parallax, no large-area movement, no looping animations outside the motion-lab scratch page. The card image zoom at 1.04× is below the 5-second / one-third-of-viewport threshold that WCAG flags.

---

## Implementation pointers

| What | Where |
|---|---|
| Token definitions (`--duration-*`, `--ease-*`) | `src/styles/global.css` `@theme` |
| Keyframes (`aod-stamp-in`, `aod-focus-pulse`) | `src/styles/global.css` (outside `@theme`) |
| Helper classes (`.aod-brand-link`, `.aod-brand-btn`, `.aod-brand-card*`, `.aod-focus-ring`, `.motion-stamp-in`) | `src/styles/global.css` |
| Reduced-motion global rule | `src/styles/global.css` bottom |
| Component consumers | `Header.astro`, `Footer.astro`, `ArticleCard.astro`, `CategoryTiles.astro`, home hero CTA, article page category pill |

---

## What this spec doesn't cover

- **Layout primitives** — see acts-of-defiance#9.
- **Button component taxonomy** (primary/secondary/ghost sizes) — see acts-of-defiance#10.
- **Page transitions** — view transitions API usage is a future ticket.
- **Scroll-linked effects** — not in v1.
