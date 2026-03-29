# Issue: Implement database schema

**Type:** feature
**Priority:** high — foundation for all dime-core work
**Repo:** dime
**Epic:** epic-dime-core

## Tables to implement

See `docs/specs/dime-data-model.md` for full schema.

| Table | Notes |
|---|---|
| `project` | Includes `content_guide` JSONB and `style_guide` JSONB columns |
| `article` | Pipeline state enum, FK to project |
| `article_checkpoint` | Lightweight git pointer (hash + optional publish snapshot) — not a content blob |
| `image_slot` | Per-article image slot definitions (role, dimensions, alt text) |
| `image_variant` | Generated image records with GCS URI |
| `publish_event` | Log of publish actions per article |
| `user` | Auth |
| `role` | Project-level role assignments |
| `workflow_config` | Per-project workflow customization (approval steps, notifications) |

## Implementation

- [ ] Alembic migrations (not raw SQL — must be reversible)
- [ ] SQLAlchemy ORM models in `dime/models/`
- [ ] Pipeline state as a Python Enum, enforced at model level
- [ ] `content_guide` and `style_guide` as JSONB — validate shape on write, not in DB constraint
- [ ] Indexes: `article(project_id, state)`, `image_slot(article_id)`

## Acceptance criteria

- [ ] `alembic upgrade head` runs clean on fresh Postgres
- [ ] `alembic downgrade base` runs clean (all migrations reversible)
- [ ] `uv run pyright` no errors on model files
- [ ] `uv run pytest tests/test_models.py` passes (basic CRUD for each table)

## Dependencies

- Resolve DECISION-001 (article versioning) before finalizing `article_checkpoint` schema
