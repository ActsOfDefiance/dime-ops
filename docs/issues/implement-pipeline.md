# Issue: Implement pipeline state machine and worker infrastructure

**Type:** feature
**Priority:** high
**Repo:** dime
**Epic:** epic-dime-core
**Blocked by:** implement-api-layer

## State machine

The 11 states of the content pipeline (see `docs/specs/dime-pipeline.md`):

```
queued → researching → research_review* → writing → writing_review* →
art_briefing (parallel: → image_generating) → final_review* → publishing → published
                                                                         ↘ failed
                                                                         ↘ archived
```
`*` = human checkpoint gate

**Rules:**
- State transitions only happen via the API (`POST /articles/{id}/state`)
- Human checkpoint states block until explicit approve/reject via API
- `failed` is reachable from any in-progress state
- `archived` is terminal

## Worker infrastructure

Workers are processes that consume tasks from the broker and perform work. Each maps to an agent.

| Worker | Consumes | Produces |
|---|---|---|
| research_worker | `research.start` | `research.done` |
| writing_worker | `writing.start` | `writing.done` |
| art_director_worker | `art_briefing.start` | `art_brief.done` |
| image_worker | `image.start` | `image.done` (per slot) |
| publisher_worker | `publishing.start` | `publishing.done` |

**Worker lifecycle:**
1. Consume task from broker
2. Run agent
3. Write results to filesystem / DB via API
4. Dispatch next task (or signal checkpoint)
5. Transition article state via API

## Implementation

```
dime/
  pipeline/
    state_machine.py   ← state definitions, valid transitions, checkpoint gates
    dispatcher.py      ← maps state to broker task type
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
- [ ] Human checkpoint states cannot be auto-advanced — require explicit API call
- [ ] Worker loop handles agent failure gracefully: marks article `failed`, logs error, does not crash
- [ ] Workers can be run as standalone processes (`python -m dime.workers.research`)
- [ ] `pytest tests/test_pipeline.py` — state machine unit tests (no DB needed)
- [ ] `pytest tests/test_workers.py` — integration tests with real broker
