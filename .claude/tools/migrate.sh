#!/usr/bin/env bash
# Usage: migrate.sh [alembic args...]
#   e.g. migrate.sh upgrade head
#        migrate.sh downgrade -1
#        migrate.sh revision --autogenerate -m "add resources table"
#        migrate.sh history
#
# Runs Alembic migrations for the dime backend.
# Must be run from the dime/ repo root.
#
# Environment variables (from .envrc):
#   DATABASE_URL   PostgreSQL connection string (required)

set -euo pipefail

# 1. Verify we're in the dime repo
if [[ ! -f "pyproject.toml" ]] || ! grep -q 'name = "dime"' pyproject.toml 2>/dev/null; then
    echo "ERROR: Must be run from the dime/ repo root." >&2
    exit 1
fi

# 2. Verify uv
if ! command -v uv &>/dev/null; then
    echo "ERROR: uv not found. Install from https://docs.astral.sh/uv/" >&2
    exit 1
fi

# 3. Verify DATABASE_URL
if [[ -z "${DATABASE_URL:-}" ]]; then
    echo "ERROR: DATABASE_URL is not set." >&2
    echo "       Source your .envrc (direnv allow) and try again." >&2
    exit 1
fi

# 4. Check Postgres is reachable
if ! pg_isready -d "$DATABASE_URL" -q 2>/dev/null; then
    echo "WARNING: PostgreSQL may not be reachable at DATABASE_URL." >&2
    echo "         Continuing anyway — Alembic will report the actual error." >&2
fi

# 5. Default to 'upgrade head' if no args
if [[ $# -eq 0 ]]; then
    echo "No arguments provided — defaulting to 'upgrade head'" >&2
    set -- upgrade head
fi

# 6. Run Alembic
echo "Running: alembic $*" >&2
uv run alembic "$@"
