# Issue: Define motion system

**Type:** design
**Priority:** low — but should land before adding more interactive components
**Repo:** acts-of-defiance
**Epic:** Epic: Design (acts-of-defiance#2)

## Goal

A small set of motion tokens (durations, easings) and interaction patterns (hover, focus, active) so transitions don't get reinvented per component.

## Scope

### Tokens
- [ ] Duration scale: `--duration-instant` (75ms), `--duration-fast` (150ms), `--duration-base` (250ms), `--duration-slow` (400ms)
- [ ] Easing scale: `--ease-out` (default), `--ease-in-out`, `--ease-spring` (for delight moments)
- [ ] `prefers-reduced-motion` rules — all transitions reduce to ~0ms or fade-only when user has it on

### Interaction patterns
- [ ] Standard hover: which token, which property (color, transform, opacity)
- [ ] Standard focus: ring style, color, offset, must meet AA contrast
- [ ] Standard active/pressed
- [ ] Card hover (article card image scale, headline color shift — already used in comps, document it)

### Implementation
- [ ] Add tokens to `global.css` `@theme`
- [ ] `prefers-reduced-motion` media query in `global.css`
- [ ] Document in `docs/specs/motion.md`

## Acceptance criteria

- [ ] `docs/specs/motion.md` exists
- [ ] All hover/focus/active transitions in components use motion tokens
- [ ] Reduced-motion verified in DevTools emulation
