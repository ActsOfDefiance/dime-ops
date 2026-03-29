# Issue: Implement left pane

**Type:** feature
**Repo:** dime-ui
**Epic:** epic-dime-ui
**Blocked by:** scaffold-dime-ui

## What it does

The left pane is the project navigator + chat interface. Always visible. Contains:

1. **Project selector** — dropdown or list of projects; switches context for entire app
2. **Article list** — articles in the current project; grouped or sorted by state; clicking selects article and drives right pane
3. **Chat thread** — conversation with dime for the current article (or project-level chat); shows agent messages, status updates, checkpoint prompts
4. **Chat input** — send message to dime; trigger pipeline; respond to checkpoints

## Key behaviors

- Selecting an article loads its state and drives the right pane to the correct view
- Chat thread auto-scrolls on new messages
- WebSocket events (pipeline state changes, agent messages) appear in chat thread in real time
- Human checkpoint prompts appear as special chat messages with approve/reject actions inline
- New article button triggers article creation via API → right pane shows `queued` state

## Components

- `ProjectSelector.svelte`
- `ArticleList.svelte` (with `ArticleListItem.svelte` — shows state badge)
- `ChatThread.svelte` (with `ChatMessage.svelte` — supports text + action buttons)
- `ChatInput.svelte`

## Acceptance criteria

- [ ] Switching projects updates article list and clears chat thread
- [ ] Clicking an article: right pane updates to correct state view
- [ ] Sending a message: appears in thread immediately (optimistic), confirmed by API
- [ ] WebSocket: new pipeline events appear without page refresh
- [ ] Checkpoint messages have functional approve/reject buttons that call the API
- [ ] Article state badges update in real time as pipeline progresses
- [ ] Vitest: `ChatMessage.svelte` unit tests (message types, action rendering)
- [ ] Storybook: stories for `ChatThread`, `ArticleList`, `ChatMessage` with all message types
