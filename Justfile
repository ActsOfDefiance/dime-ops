# Acts of Defiance — command center
# Run `just` to list all available commands.
# Run `just doctor` before starting any session.

default:
    @just --list

# ── Setup ─────────────────────────────────────────────────────────────────────

# Verify full development environment
doctor:
    @bash setup/doctor.sh

# Create symlinks in all sibling repos
link:
    @bash setup/link.sh

# ── dime (Python backend) ─────────────────────────────────────────────────────

# Start dime API server
dime-dev:
    cd ../dime && uv run python -m dime start

# Run dime test suite
dime-test *args:
    cd ../dime && uv run pytest {{args}}

# Run dime integration tests (requires Postgres + Redis)
dime-test-integration:
    cd ../dime && uv run pytest -m integration

# Type check dime
dime-check:
    cd ../dime && uv run pyright

# Lint dime
dime-lint:
    cd ../dime && uv run ruff check

# Format dime
dime-format:
    cd ../dime && uv run ruff format

# Run all dime quality checks
dime-ci: dime-lint dime-check dime-test

# ── dime-ui (Svelte frontend) ──────────────────────────────────────────────────

# Start dime-ui dev server
ui-dev:
    cd ../dime-ui && bun run dev

# Run dime-ui test suite
ui-test:
    cd ../dime-ui && bun run test

# Type check dime-ui
ui-check:
    cd ../dime-ui && bun run check

# Build dime-ui
ui-build:
    cd ../dime-ui && bun run build

# Start Storybook
ui-storybook:
    cd ../dime-ui && bun run storybook

# Run Playwright e2e tests
ui-e2e:
    cd ../dime-ui && bun run test:e2e

# Run all ui quality checks
ui-ci: ui-check ui-test

# ── acts-of-defiance (site) ────────────────────────────────────────────────────

# Start Hugo dev server
site-dev:
    cd ../acts-of-defiance && hugo server

# Build site
site-build:
    cd ../acts-of-defiance && hugo --minify

# ── cross-repo ─────────────────────────────────────────────────────────────────

# Run all CI checks across all repos
ci: dime-ci ui-ci
