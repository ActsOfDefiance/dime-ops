# Design Standards

These standards apply to all design and development work across the dime ecosystem. Feature workflows and design work must reference and comply with these standards.

## Sub-specs

The design system is split into focused specs that this document references:

- **Typography** → [`typography.md`](./typography.md) — modular scale, fluid type, section head variants, prose contract
- **Spacing & vertical rhythm** → [`spacing.md`](./spacing.md) — atomic scale, semantic layer, container widths, vertical rhythm
- **Motion** → [`motion.md`](./motion.md) — brand-named easings, off-grid durations, letterpress + risograph interaction patterns, reduced-motion rules
- **Layout primitives** → [`layout.md`](./layout.md) — Container, Stack, Cluster, Grid, Center composable components
- *Buttons & links* — pending (acts-of-defiance#10)

When adding new UI, check the relevant sub-spec first. Don't introduce ad-hoc tokens or component variants — extend the spec.

## Accessibility — WCAG 2.2 (AA)

All user-facing interfaces must meet WCAG 2.2 Level AA compliance. This is not optional and not deferred — it applies from the first component.

Key requirements:
- Semantic HTML and proper ARIA attributes
- Keyboard navigability for all interactive elements
- Sufficient color contrast ratios (4.5:1 for normal text, 3:1 for large text)
- Focus indicators visible and meaningful
- Screen reader compatibility
- Motion/animation respects `prefers-reduced-motion`
- Form inputs have visible labels and error states
- Touch targets minimum 24x24 CSS pixels

## Performance

Speed, resource efficiency, and payload size must be considered in all design and development decisions. Performance is a feature, not an afterthought.

### Application speed
- Prioritize perceived performance (fast first paint, progressive loading)
- Avoid unnecessary re-renders and DOM thrashing
- Use lazy loading for non-critical resources
- Server-side render critical content where possible

### CPU and memory
- Minimize JavaScript execution cost
- Avoid memory leaks (clean up subscriptions, event listeners, timers)
- Profile before optimizing — measure, don't guess
- Prefer CSS for visual effects over JavaScript

### Payload and app size
- Tree-shake aggressively — no unused dependencies
- Code-split routes and heavy components
- Optimize images (format, compression, responsive sizing)
- Monitor bundle size — regressions are bugs
- Prefer lightweight dependencies; justify heavy ones
