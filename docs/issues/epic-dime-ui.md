# Epic: Dime UI

**Type:** feature
**Priority:** medium — needs working API to connect to
**Blocked by:** epic-dime-core (API contract must be stable)

## Goal

A Svelte/SvelteKit two-pane chat dashboard. Left pane: project list + chat thread. Right pane: state-driven, shows the right view for the current pipeline state. Real-time updates via WebSocket.

## Decisions to resolve first

- [ ] DECISION-002: Confirm shadcn-svelte + Stitch as UI framework (current recommendation — validate before scaffolding)
- [ ] DECISION-005: Workflow config UI — where does the user configure roles, notifications, approval steps?

## Sub-issues

### Scaffold
- [ ] [scaffold-dime-ui.md](scaffold-dime-ui.md) — SvelteKit + Bun + shadcn-svelte + Stitch; base layout, routing skeleton, Vitest + Storybook + Playwright setup

### Left pane
- [ ] [implement-left-pane.md](implement-left-pane.md) — project list, article list, chat thread, send/receive messages, WebSocket connection

### Right pane
- [ ] [implement-right-pane.md](implement-right-pane.md) — state router; all 11 pipeline state views: status card, research viewer, draft editor, art brief viewer, image review, Package Dashboard, publish confirmation

### Package Dashboard
- [ ] [implement-package-dashboard.md](implement-package-dashboard.md) — final_review state: rendered markdown preview, image slots at target dimensions, metadata summary, approve/reject/request changes actions

### Cross-cutting
- [ ] Inline editing overlay (draft state: human can edit article text before approve)
- [ ] Notification indicator (in-app WebSocket alerts for human checkpoints)

## Order

```
DECISION-002 + DECISION-005 (resolve first)
    ↓
scaffold-dime-ui
    ↓
implement-left-pane (connect WebSocket)
implement-right-pane (state router + all state views)
    ↓ (depends on right-pane)
implement-package-dashboard
inline editing
notification indicator
```

## Definition of Done

- [ ] `bun run test` (Vitest) passes
- [ ] `bun run check` (svelte-check + TypeScript) no errors
- [ ] Storybook has stories for all major components
- [ ] Playwright e2e: create project → trigger pipeline → approve checkpoint → see Package Dashboard
- [ ] WebSocket reconnects automatically on drop
- [ ] Right pane correctly displays all 11 pipeline states
- [ ] Inline editing saves changes back to API (does not bypass state machine)
