# Issue: Implement right pane (state-driven views)

**Type:** feature
**Repo:** dime-ui
**Epic:** epic-dime-ui
**Blocked by:** scaffold-dime-ui, implement-left-pane (needs article selection mechanism)

## What it does

The right pane shows a different view depending on the current article's pipeline state. It's a state router: one component per state, all mounted in the same slot.

## State → view mapping

| State | Right pane shows |
|---|---|
| `queued` | Article config form (title, type, brief) + Start button |
| `researching` | Live status card: "Researching…" + spinner + agent log tail |
| `research_review` | Research notes viewer + Approve / Request changes buttons |
| `writing` | Live status card: "Writing…" |
| `writing_review` | Draft viewer + inline editing + Approve / Request changes |
| `art_briefing` | Live status card: "Creating art brief…" |
| `image_generating` | Image slots grid: each slot shows generation status / result thumbnail |
| `final_review` | **Package Dashboard** (see implement-package-dashboard.md) |
| `publishing` | Live status card: "Publishing…" |
| `published` | Publish confirmation: date, link if available, archive option |
| `failed` | Error details + Retry / Archive buttons |
| `archived` | Read-only article summary |

## Inline editing (writing_review state)

- Article body is displayed as editable rich text (or CodeMirror markdown editor)
- Edits are sent to `PATCH /articles/{id}` on save (not on every keystroke)
- Editing does not bypass the state machine — the article stays in `writing_review` until explicitly approved
- Unsaved changes indicator

## Implementation

```
src/
  lib/
    components/
      right-pane/
        RightPane.svelte          ← state router
        states/
          Queued.svelte
          Researching.svelte
          ResearchReview.svelte
          Writing.svelte
          WritingReview.svelte    ← includes inline editor
          ArtBriefing.svelte
          ImageGenerating.svelte
          FinalReview.svelte      ← delegates to PackageDashboard
          Publishing.svelte
          Published.svelte
          Failed.svelte
          Archived.svelte
        StatusCard.svelte          ← reused by in-progress states
        InlineEditor.svelte        ← markdown editor component
```

## Acceptance criteria

- [ ] Switching articles or receiving a WebSocket state-change event updates the right pane immediately
- [ ] All 11 state views render without errors (can be stubs initially, fill in over time)
- [ ] Inline editor: saves via API, shows unsaved indicator, does not navigate away on save
- [ ] In-progress status cards (researching, writing, etc.) show live agent log updates via WebSocket
- [ ] Storybook: stories for each state view
