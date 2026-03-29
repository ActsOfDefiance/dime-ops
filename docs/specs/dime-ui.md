# Dime — UI & Presentation Layer

## Stack

Svelte/SvelteKit. The presentation layer is fully decoupled from dime internals — it speaks REST + WebSocket only. It can be hosted locally or on Cloud Run with zero backend changes.

Reference wireframes: `docs/wireframes/dime-ui-chat-panes.html`

## Layout

- **Top bar:** project name / article title / current state badge / user avatar
- **Left pane:** chat history + message input + approve/reject buttons (visible at all checkpoints)
- **Right pane:** state-driven contextual content — the active component changes based on `article.state`

The approve/reject actions live in the left pane, not the right. The right pane is for content; the left is for decisions and conversation.

## Right Pane by State

| State | Right pane component |
|---|---|
| `researching` | Live streaming research output |
| `research_review` | Research notes viewer, inline editor, sources list, raw .md tab |
| `writing` | Live streaming draft output |
| `draft_review` | Rich text editor (markdown-backed), article preview |
| `art_briefing` | Live brief generation |
| `art_review` | Prompt editor with style guide constraints visible |
| `art_generating` | Image studio: prompt editor, variant grid, compare, select |
| `final_review` | Package Dashboard — rendered article + images at slot sizes + metadata editor |
| `approved` | Package summary + publish controls (schedule / publish now) |

## API Contract

The frontend only needs three things:
1. `article.state` — determines which right-pane component mounts
2. Content payload for the current state — returned with the article
3. WebSocket event stream — agent progress, state changes, task completion, notifications

REST endpoints: CRUD for articles, projects, users; checkpoint actions (approve / reject / edit).

The Svelte app never imports dime Python code or business logic.

## Inline Editing

Human edits in the right pane trigger a debounced REST PATCH. The API writes to the filesystem via `FileSystemAdapter`. Dime acknowledges the change in the chat pane.

## Notifications

In-app notifications arrive via WebSocket. Badge count updates even if the tab is backgrounded. Out-of-band adapters (email, Slack, SMS) fire additionally if configured — see [dime-workflows.md](dime-workflows.md).

## Deferred: UI Framework & Design System

See `docs/decisions/open-decisions.md` DECISION-002. Short version: shadcn-svelte is the leading candidate for component library; Stitch MCP is available to generate the design system and style tokens before committing.
