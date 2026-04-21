# Layout Primitives

Composable layout components for Acts of Defiance. These are thin Astro wrappers that absorb the ad-hoc flex/grid utility patterns scattered across page templates into named, token-enforcing primitives.

**Status:** v1, established by acts-of-defiance#9.
**Depends on:** [spacing](./spacing.md) (#7 — provides the `--spacing-*` and `--container-*` tokens these primitives consume).
**Reference:** [every-layout.dev](https://every-layout.dev) — the canonical source for this pattern.

---

## Primitives

All live in `src/components/layout/`.

### Container

Max-width + horizontal padding wrapper. Every page-level content block should be wrapped in a Container.

```astro
import Container from "../components/layout/Container.astro";

<Container>                              <!-- default: content (1280px) -->
<Container width="hero">                 <!-- hero text block (896px) -->
<Container width="reading">              <!-- long-form prose (700px) -->
<Container as="section" class="py-section-y">
```

| Prop | Type | Default | Description |
|---|---|---|---|
| `width` | `"reading" \| "hero" \| "content"` | `"content"` | Maps to `max-w-{width}` (consumes `--container-*` tokens) |
| `padded` | `boolean` | `true` | Whether to apply horizontal padding |
| `as` | `string` | `"div"` | HTML element to render |
| `class` | `string` | `""` | Extra classes |

**Generated classes:** `max-w-{width} mx-auto [px-container-x md:px-container-x-lg]` (padding omitted when `padded={false}`)

Container applies responsive horizontal padding by default (`24px mobile, 48px tablet+`). When a parent already provides padding, use `padded={false}` instead of `class="!px-0"`.

### Stack

Vertical rhythm with token-based gap. Replaces `space-y-*` and `flex flex-col gap-*` patterns.

```astro
import Stack from "../components/layout/Stack.astro";

<Stack>                           <!-- default gap: stack (32px) -->
<Stack gap="sm">                  <!-- tighter: 16px -->
<Stack gap="section-y" as="ul">   <!-- section break -->
```

| Prop | Type | Default | Description |
|---|---|---|---|
| `gap` | `string` | `"stack"` | Spacing token name (maps to `gap-{token}`) |
| `as` | `string` | `"div"` | HTML element to render |
| `class` | `string` | `""` | Extra classes |

**Generated classes:** `flex flex-col gap-{token}`

**Note:** `flex flex-col` defaults to `align-items: stretch`. If children should be intrinsically sized (e.g. an inline badge), add `class="items-start"`.

### Cluster

Wrapping inline group with token-based gap. For chip rows, tag lists, nav link groups, button sets.

```astro
import Cluster from "../components/layout/Cluster.astro";

<Cluster>                                  <!-- default gap: inline (12px) -->
<Cluster gap="2xs">                        <!-- tighter: 8px -->
<Cluster gap="lg" justify="center">        <!-- centered footer nav -->
```

| Prop | Type | Default | Description |
|---|---|---|---|
| `gap` | `string` | `"inline"` | Spacing token name |
| `justify` | `"start" \| "center" \| "end" \| "between"` | — | justify-content |
| `align` | `"start" \| "center" \| "end" \| "baseline"` | — | align-items |
| `as` | `string` | `"div"` | HTML element to render |
| `class` | `string` | `""` | Extra classes |

**Generated classes:** `flex flex-wrap gap-{token} [justify-*] [items-*]`

### Grid

Responsive column grid with token-based gap. Uses explicit breakpoint columns (not CSS auto-fit) because the editorial layout is intentionally designed per breakpoint.

```astro
import Grid from "../components/layout/Grid.astro";

<Grid>                                     <!-- 1 / md:2 / lg:3, gap card-gap -->
<Grid cols="1 sm:2 lg:4" gap="md">        <!-- category tiles -->
<Grid cols="1 md:3" gap="lg" as="ul">     <!-- related articles -->
```

| Prop | Type | Default | Description |
|---|---|---|---|
| `cols` | `string` | `"1 md:2 lg:3"` | Space-separated column spec (e.g. `"1 md:2 lg:3"`) |
| `gap` | `string` | `"card-gap"` | Spacing token name |
| `as` | `string` | `"div"` | HTML element to render |
| `class` | `string` | `""` | Extra classes |

The `cols` string is parsed into Tailwind responsive grid-cols classes:
- `"1 md:2 lg:3"` → `grid-cols-1 md:grid-cols-2 lg:grid-cols-3`
- `"1 md:3"` → `grid-cols-1 md:grid-cols-3`

**Generated classes:** `grid grid-cols-{n} [bp:grid-cols-{n}]... gap-{token}`

### Center

Horizontally centers content via `text-center`. For centering a block with max-width, use Container instead.

```astro
import Center from "../components/layout/Center.astro";

<Center>
  <SectionHead variant="editorial">What we cover</SectionHead>
</Center>
<Center class="py-section-y">
  <p>No stories yet.</p>
</Center>
```

| Prop | Type | Default | Description |
|---|---|---|---|
| `as` | `string` | `"div"` | HTML element to render |
| `class` | `string` | `""` | Extra classes |

**Generated classes:** `text-center`

---

## Usage rules

### When to use which primitive

| Pattern | Primitive |
|---|---|
| Page-width content area with max-width + padding | **Container** |
| Vertical list of elements with consistent spacing | **Stack** |
| Horizontal wrapping group (tags, chips, buttons, nav) | **Cluster** |
| Multi-column responsive grid | **Grid** |
| Centered text or empty-state message | **Center** |

### Composing primitives

Primitives compose naturally:

```astro
<!-- Page section: Container + Grid -->
<Container as="section" class="py-section-y">
  <Grid>
    <ArticleCard ... />
  </Grid>
</Container>

<!-- Footer: Container + Stack + Cluster -->
<Container width="hero">
  <Stack gap="lg">
    <p>Tagline</p>
    <Cluster as="nav" gap="lg" justify="center">
      <a>Link 1</a>
      <a>Link 2</a>
    </Cluster>
  </Stack>
</Container>
```

### Forbidden patterns

```astro
<!-- No raw max-w + mx-auto + px in page templates -->
<div class="max-w-content mx-auto px-container-x md:px-container-x-lg">

<!-- No raw space-y-* in page templates -->
<div class="space-y-lg">

<!-- No raw grid grid-cols in page templates -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-lg">

<!-- No raw flex flex-wrap gap-* in page templates -->
<div class="flex flex-wrap gap-sm">
```

Use the primitives instead. The raw utility patterns are allowed in:
1. **Components with specialized layout needs** (e.g. the hero gradient overlay, the content version selector tabs) where the pattern doesn't map to a primitive.
2. **Scratch/lab pages** (motion-lab.astro) that aren't shipped in production nav.

---

## Relationship to the design standards

This spec is referenced from `docs/specs/design-standards.md` under the sub-specs index. The primitives consume tokens from [spacing.md](./spacing.md) and are consumed by page templates.
