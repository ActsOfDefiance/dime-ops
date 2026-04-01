# Issue: Configure dime project dependencies and tooling

**Type:** tooling
**Priority:** high — blocks implement-db-schema, implement-adapters, implement-api-layer
**Repo:** dime
**Epic:** epic-dime-core
**GitHub:** ActsOfDefiance/dime#20
**Blocks:** #14, #15, #16, #17, #18, #19

## Problem

The `dime` repo's `pyproject.toml` only has `google-adk` as a runtime dependency and a minimal dev toolchain. Before any epic-dime-core implementation work can begin, the full dependency set must be declared, installed, and verified.

## Dependencies to add

### Runtime

```toml
[project.dependencies]
fastapi = ">=0.115.0"
uvicorn = {extras = ["standard"], version = ">=0.32.0"}
sqlalchemy = {extras = ["asyncio"], version = ">=2.0.0"}
alembic = ">=1.14.0"
asyncpg = ">=0.30.0"          # async Postgres driver (SQLAlchemy async)
psycopg = {extras = ["binary"], version = ">=3.2.0"}  # Alembic CLI + sync use
redis = ">=5.0.0"             # BrokerAdapter (Redis Streams)
google-cloud-storage = ">=2.19.0"  # FileSystemAdapter GCS
pydantic-settings = ">=2.0.0" # settings management
google-adk = ">=1.0.0"        # keep existing
```

### Dev

```toml
[project.optional-dependencies]
dev = [
    "pyright>=1.1.390",
    "pytest>=8.0.0",
    "pytest-cov>=4.1.0",
    "pytest-asyncio>=0.23.0",
    "pytest-mock>=3.14.0",
    "httpx>=0.27.0",
    "ruff>=0.8.0",
]
```

## Alembic setup

- [ ] Run `alembic init migrations` in the `dime/` root
- [ ] Configure `alembic.ini`: set `sqlalchemy.url` to read from env (`DATABASE_URL`)
- [ ] Configure `migrations/env.py` to import dime models (for autogenerate support)
- [ ] Verify `alembic upgrade head` and `alembic downgrade base` run clean on empty DB

## pytest configuration

Per DECISION-009:

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
markers = [
    "integration: requires Postgres, Redis, or GCS (deselect with -m 'not integration')",
]
addopts = "-m 'not integration'"  # unit tests only by default
```

## pyright configuration

```toml
[tool.pyright]
pythonVersion = "3.13"
typeCheckingMode = "strict"
venvPath = "."
venv = ".venv"
```

## Directory scaffolding

Create empty `__init__.py` stubs for the package structure that will be built out in subsequent issues:

```
dime/
  models/           ← implement-db-schema
  adapters/         ← implement-adapters
  api/              ← implement-api-layer
  pipeline/         ← implement-pipeline
  workers/          ← implement-pipeline
  agents/           ← implement-agents (already partially exists, may need restructure)
```

## Acceptance criteria

- [ ] `uv sync --all-extras` completes with no errors
- [ ] `uv run pyright dime/` runs without configuration errors (zero files = ok)
- [ ] `uv run ruff check dime/` passes
- [ ] `uv run pytest` (unit only) passes — existing tests still green
- [ ] `uv run alembic upgrade head` runs clean on a fresh local Postgres
- [ ] `uv run alembic downgrade base` runs clean
- [ ] Directory stubs in place
