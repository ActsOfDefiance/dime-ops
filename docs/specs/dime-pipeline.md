# Dime — Content Pipeline & State Machine

## States

### Core states (always present)

```
queued
  → researching              (worker: ResearchAgent)
  → writing                  (worker: WriterAgent)
  → art_briefing             (worker: ArtDirectorAgent)
  → image_generating         (worker: ImageAgent)
  → publishing               (PublishingAdapter.publish())
  → published
  ↘ failed                   (reachable from any in-progress state)
  ↘ archived                 (terminal)
```

### Checkpoint states (configurable per-project)

After each agent phase, the pipeline can optionally pause at a review checkpoint. Which checkpoints are active is controlled by `workflow_config.checkpoints` — see [dime-data-model.md](dime-data-model.md).

```
researching → [researching_review] → writing → [writing_review] →
art_briefing → [art_briefing_review] → image_generating → [image_review] →
[final_review] → publishing → published
```

`[ ]` = configurable checkpoint. When disabled, the pipeline advances automatically.

### Revision states (entered via retry)

When a human retries at a checkpoint, the article enters a revision state. The same agent re-runs with the original artifact plus the human's feedback, producing a modified artifact.

```
researching_revision
writing_revision
art_briefing_revision
image_revision
```

## Checkpoint Actions

At every active checkpoint, the human has three actions:

### Approve
Advance to the next state. The artifact is accepted as-is.

### Retry
**Modifies the current artifact.** The human provides feedback describing what should change. The article enters `{phase}_revision` — the same agent re-runs with the existing artifact plus feedback injected as context. The agent edits the artifact (not starting over). After revision, the article returns to the same checkpoint for another review.

Transitions: `{phase}_review` → `{phase}_revision` → `{phase}_review`

### Reject
**Starts the phase from scratch.** The human provides rejection reasons and instructions for doing it better. The article re-enters the original `{phase}` state — the agent runs fresh with the rejection context (why it was rejected, what to do differently). A new artifact is produced. After completion, the article returns to the same checkpoint.

Transitions: `{phase}_review` → `{phase}` → `{phase}_review`

### Retry vs Reject summary

| Action | Agent receives | Artifact | Result |
|---|---|---|---|
| Retry | Current artifact + edit feedback | Modified in place | Returns to checkpoint |
| Reject | Rejection reasons + instructions | New from scratch | Returns to checkpoint |

## Sequential Execution

All phases execute sequentially. Art briefing must complete before image generation begins — the brief is the input to the image agent. There is no parallel execution between phases.

## Final Review — Package Dashboard

`final_review` is a whole-package checkpoint. It does not render a site preview (dime is decoupled from the CMS). Instead it shows a Package Dashboard:

- Rendered markdown (dime's own renderer)
- Images at intended slot sizes with slot labels
- Frontmatter / metadata editor
- Raw markdown (collapsible)

At `final_review`, retry and reject target a specific prior phase (the human chooses which phase to send back to). This allows catching issues in any part of the package.

If the active `PublishingAdapter` implements `preview_url()` and a dev server is running, an optional live preview link is surfaced. This is progressive enhancement — never required.

## Re-entry After Publish

- `published → writing_review`: update the article (re-enters the writing checkpoint)
- `published → publishing`: republish with updated metadata only
- `published → archived`: remove from publish queue (content stays in compendium)

## Error Handling

- `failed` is reachable from any in-progress or revision state
- A failed article can be retried from the state it failed in, or sent back to an earlier state
- `archived` is terminal — no transitions out
