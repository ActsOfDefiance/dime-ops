# Issue: Implement API layer

**Type:** feature
**Priority:** high
**Repo:** dime
**Epic:** epic-dime-core
**Blocked by:** implement-db-schema, implement-adapters

## Scope

FastAPI application: REST endpoints + WebSocket. The API is the only thing that touches the database directly. Agents and workers talk to the API, not directly to the DB.

## Endpoints

### Projects
- `POST /projects` — create project (includes content_guide, style_guide)
- `GET /projects` — list projects
- `GET /projects/{id}` — get project + articles
- `PATCH /projects/{id}` — update project settings
- `GET /projects/{id}/content-guide` — return content_guide for agent injection

### Articles
- `POST /projects/{id}/articles` — create article (sets state: queued)
- `GET /articles/{id}` — get article + current state + checkpoint info
- `POST /articles/{id}/start` — trigger pipeline (queued → researching)
- `POST /articles/{id}/approve` — advance through human checkpoint
- `POST /articles/{id}/reject` — return to previous state with note
- `PATCH /articles/{id}` — update article fields (title, body — inline editing)
- `GET /articles/{id}/package` — Package Dashboard data (rendered content + image slots)

### Images
- `GET /articles/{id}/image-slots` — list image slots + current variants
- `POST /articles/{id}/image-slots/{slot}/regenerate` — trigger new image generation

### Pipeline state (internal — called by workers, not UI directly)
- `POST /articles/{id}/state` — transition state (validated against state machine)

### WebSocket
- `WS /ws/{project_id}` — push pipeline events to connected clients

## Acceptance criteria

- [ ] All endpoints return correct HTTP status codes
- [ ] State machine transitions are enforced — invalid transitions return 422
- [ ] WebSocket pushes state change events to connected clients
- [ ] `pyright` no errors
- [ ] `pytest tests/test_api.py` passes against real Postgres (not mocked)
- [ ] OpenAPI schema auto-generated and accurate

## Notes

- State machine logic lives here, not in the agents or UI
- content_guide endpoint is how agents get editorial context — must be fast
