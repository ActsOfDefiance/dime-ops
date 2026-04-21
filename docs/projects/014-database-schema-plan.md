# Issue #14 — Implement Database Schema: Implementation Plan

## Branch
`feature/014-database-schema`

## Files to Create

| File | Purpose |
|---|---|
| `dime/pipeline/states.py` | `ArticleState` enum (12 states) |
| `dime/pipeline/__init__.py` | Re-export `ArticleState` |
| `dime/db.py` | Async engine + `AsyncSession` factory |
| `dime/models/base.py` | `DeclarativeBase` with UUID/timestamptz helpers |
| `dime/models/role.py` | `Role` model |
| `dime/models/workflow_config.py` | `WorkflowConfig` model |
| `dime/models/user.py` | `User` model (FK → role) |
| `dime/models/project.py` | `Project` model (JSONB x2, FK → workflow_config) |
| `dime/models/article.py` | `Article` model (state enum, FKs → project/user/checkpoint) |
| `dime/models/article_checkpoint.py` | `ArticleCheckpoint` model (git pointer) |
| `dime/models/image_slot.py` | `ImageSlot` model |
| `dime/models/image_variant.py` | `ImageVariant` model |
| `dime/models/publish_event.py` | `PublishEvent` model |
| `dime/models/__init__.py` | Re-export all models (Alembic discovery) |
| `alembic.ini` | Alembic config |
| `alembic/env.py` | Async migration runner, imports Base.metadata |
| `alembic/script.py.mako` | Migration template |
| `alembic/versions/<hash>_initial_schema.py` | Initial migration (all tables, reversible) |
| `tests/test_models.py` | Unit + integration tests |

## Key Architecture Decisions

1. **Circular FKs** — `article ↔ article_checkpoint` and `image_slot ↔ image_variant`
   use `use_alter=True` on nullable side (current_draft_id, selected_variant_id).
2. **Async DB** — `create_async_engine` with `postgresql+asyncpg://` scheme.
   Alembic env.py uses `run_async_migrations()` pattern.
3. **JSONB** — `sqlalchemy.dialects.postgresql.JSONB` for all JSON columns.
4. **Array** — `sqlalchemy.dialects.postgresql.ARRAY(Text)` for `article.tags`.
5. **UUID PKs** — `Uuid` mapped column with `default=uuid.uuid4`.
6. **Tests** — Unit (default run): enum values, `__tablename__`, column presence.
   Integration (`@pytest.mark.integration`, excluded by default): CRUD per table.

## Indexes
- `article(project_id, state)` — composite
- `image_slot(article_id)` — single column

## Implementation Order
1. pipeline/states.py (enum)
2. models/base.py (declarative base)
3. db.py (engine + session)
4. models/ (all ORM models)
5. alembic setup + initial migration
6. tests/test_models.py
