# Issue: Implement pipeline state machine and worker infrastructure

**Type:** feature
**Priority:** high
**Repo:** dime
**Epic:** epic-dime-core
**Blocked by:** implement-api-layer

## State machine

The content pipeline has core states, configurable checkpoint states, and revision states (see `docs/specs/dime-pipeline.md`):

### Core flow
```
queued → researching → [researching_review] → writing → [writing_review] →
art_briefing → [art_briefing_review] → image_generating → [image_review] →
[final_review] → publishing → published
```
`[ ]` = configurable checkpoint (enabled/disabled per-project via `workflow_config`)

### Additional states
- `researching_revision`, `writing_revision`, `art_briefing_revision`, `image_revision` — entered via retry at checkpoint
- `failed` — reachable from any in-progress or revision state
- `archived` — terminal

**Rules:**
- State transitions only happen via the API (`POST /articles/{id}/state`)
- Checkpoints are configurable per-project via `workflow_config.checkpoints`
- When a checkpoint is disabled, the pipeline advances automatically
- All phases execute sequentially (no parallel execution)
- `failed` is reachable from any in-progress state
- `archived` is terminal

### Checkpoint actions (approve / retry / reject)

At every active checkpoint, the human has three actions:

| Action | What happens | Artifact result |
|---|---|---|
| **Approve** | Advance to next state | Accepted as-is |
| **Retry** | Enter `{phase}_revision` with feedback | Agent modifies existing artifact |
| **Reject** | Re-enter `{phase}` with rejection notes + instructions | Agent produces new artifact from scratch |

Both retry and reject return to the same checkpoint after the agent completes.

## Worker infrastructure

Workers are processes that consume tasks from the broker and perform work. Each maps to an agent.

| Worker | Consumes | Produces |
|---|---|---|
| research_worker | `research.start`, `research.revise` | `research.done` |
| writing_worker | `writing.start`, `writing.revise` | `writing.done` |
| art_director_worker | `art_briefing.start`, `art_briefing.revise` | `art_brief.done` |
| image_worker | `image.start`, `image.revise` | `image.done` (per slot) |
| publisher_worker | `publishing.start` | `publishing.done` |

**Worker lifecycle:**
1. Consume task from broker
2. Run agent (with revision feedback or rejection context if applicable)
3. Write results to filesystem / DB via API
4. Dispatch next task (or signal checkpoint)
5. Transition article state via API

**Revision task payloads** include `feedback` (human's edit instructions) and the existing artifact path. The agent modifies in place.

**Rejection task payloads** include `rejection.reasons` and `rejection.instructions`. The agent starts fresh with this context.

## Implementation

```
dime/
  pipeline/
    state_machine.py   ← state definitions, valid transitions, checkpoint gates, revision routing
    dispatcher.py      ← maps state + action to broker task type
  workers/
    base.py            ← worker loop: consume → run → dispatch
    research.py
    writing.py
    art_director.py
    image.py
    publisher.py
```

## Acceptance criteria

- [ ] `state_machine.py`: all invalid transitions raise `InvalidTransitionError`
- [ ] Configurable checkpoints: skipped when `workflow_config` sets `required: false`
- [ ] Checkpoint actions: approve advances, retry enters revision state, reject re-enters phase state
- [ ] Revision states: agent receives existing artifact + feedback, modifies in place
- [ ] Rejection: agent receives rejection context, produces new artifact from scratch
- [ ] Human checkpoint states cannot be auto-advanced — require explicit API call
- [ ] Worker loop handles agent failure gracefully: marks article `failed`, logs error, does not crash
- [ ] Workers can be run as standalone processes (`python -m dime.workers.research`)
- [ ] `pytest tests/test_pipeline.py` — state machine unit tests (no DB needed)
- [ ] `pytest tests/test_workers.py` — integration tests with real broker
