# Design Standards

These standards apply to all design and development work across the dime ecosystem. Feature workflows and design work must reference and comply with these standards.

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
