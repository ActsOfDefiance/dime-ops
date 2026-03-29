# Issue: Scaffold dime-ui

**Type:** feature
**Priority:** high — must exist before any UI work
**Repo:** dime-ui (new repo)
**Epic:** epic-dime-ui
**Blocked by:** DECISION-002 (confirm shadcn-svelte + Stitch)

## What to set up

- [ ] SvelteKit project with Bun as package manager (`bunx sv create`)
- [ ] TypeScript strict mode
- [ ] shadcn-svelte installed and configured
- [ ] Base layout: two-pane shell (left sidebar + right content area)
- [ ] SvelteKit routing skeleton:
  - `/` → redirect to first project or project list
  - `/projects/[id]` → main app view (two-pane)
  - `/projects/[id]/articles/[articleId]` → deep-link to specific article
- [ ] API client module (`src/lib/api.ts`) — typed fetch wrapper for dime REST API
- [ ] WebSocket client module (`src/lib/ws.ts`) — connection manager with reconnect
- [ ] Vitest configured
- [ ] Storybook configured (for component isolation)
- [ ] Playwright configured (for e2e)
- [ ] `.env.local` template with `VITE_API_URL`, `VITE_WS_URL`
- [ ] `bun run dev`, `bun run test`, `bun run build`, `bun run check` all work

## Notes

- No React. No Node/npm. Bun only.
- Do NOT use Next.js conventions — this is SvelteKit.
- Stitch: use for generating initial component variants if available; see DECISION-002
- Use svelte-check for TypeScript validation (not tsc directly)

## Acceptance criteria

- [ ] `bun run dev` starts with no errors
- [ ] `bun run check` (svelte-check) passes
- [ ] `bun run test` (Vitest) passes (at least one smoke test)
- [ ] `bun run build` produces a valid build
- [ ] Two-pane layout renders with placeholder content in both panes
- [ ] API client makes a test request to `VITE_API_URL/health` successfully
