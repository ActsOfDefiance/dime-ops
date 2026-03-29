# Dime — Content Pipeline & State Machine

## States

```
queued
  → researching          (worker: ResearchAgent)
  → research_review      (human checkpoint ✋)
  → writing              (worker: WriterAgent)
  → draft_review         (human checkpoint ✋)
  → art_briefing         (worker: ArtDirectorAgent) [can run parallel to draft_review]
  → art_review           (human checkpoint ✋)
  → art_generating       (worker: ImageAgent — interactive, human iterates in UI)
  → final_review         (human checkpoint ✋)
  → approved
  → publishing           (PublishingAdapter.publish())
  → published
```

## Human Checkpoints

At each `*_review` state the pipeline blocks until the human acts. Actions available at every checkpoint:

- **Approve** — advance to next state
- **Reject** — return to a specified prior state
- **Edit inline** — modify the artifact in the right pane directly
- **Chat** — ask dime to make changes (dispatches a new bounded agent task)

## Special Cases

**`art_generating` is semi-interactive.** Unlike other agent states that run and hand off, the human stays here to iterate on prompts, generate variants, and compare results before advancing to `final_review`. Multiple generation rounds happen within this single state.

**Parallel execution.** `art_briefing` can begin while the human is in `draft_review`. The art director reads the current draft and generates prompts in the background. The human sees the brief ready when they finish with the draft.

**Re-entry after publish.**
- `published → draft_review`: update the article
- `published → approved`: unpublish (removes from publish queue, content stays in compendium)

## Final Review — Package Dashboard

`final_review` does not render a site preview (dime is decoupled from the CMS). Instead it shows a Package Dashboard:

- Rendered markdown (dime's own renderer)
- Images at intended slot sizes with slot labels
- Frontmatter / metadata editor
- Raw markdown (collapsible)

If the active `PublishingAdapter` implements `preview_url()` and a dev server is running, an optional live preview link is surfaced. This is progressive enhancement — never required.
