#!/usr/bin/env bash
# Checks the full ActsOfDefiance development environment.
# Reports ✓ OK / ✗ FAIL / ⚑ WARN for each check with fix instructions.

DIME_OPS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$DIME_OPS_DIR")"

pass=0; fail=0; warn=0

ok()   { echo "  ✓ $1"; ((pass++)) || true; }
fail() { echo "  ✗ $1"; echo "    fix: $2"; ((fail++)) || true; }
warn() { echo "  ⚑ $1"; echo "    note: $2"; ((warn++)) || true; }

# ── Sibling repos ──────────────────────────────────────────────────────────────
echo ""
echo "── Repos ──"

# Required repos (fail if missing)
for repo in dime acts-of-defiance compendium; do
  if [ -d "$PARENT_DIR/$repo" ]; then
    ok "$repo present at $PARENT_DIR/$repo"
  else
    fail "$repo not found" "clone or create $repo at $PARENT_DIR/$repo"
  fi
done

# Optional repos (warn if missing — may not be created yet)
for repo in dime-ui; do
  if [ -d "$PARENT_DIR/$repo" ]; then
    ok "$repo present at $PARENT_DIR/$repo"
  else
    warn "$repo not found" "create when ready: gh repo create ActsOfDefiance/$repo --public"
  fi
done

# ── Symlinks ───────────────────────────────────────────────────────────────────
echo ""
echo "── Symlinks ──"

REPOS=("dime" "dime-ui" "acts-of-defiance" "compendium")
SUBDIRS=("memory" "specs" "decisions" "wireframes" "issues" "projects")

for repo in "${REPOS[@]}"; do
  repo_dir="$PARENT_DIR/$repo"
  [ -d "$repo_dir" ] || continue
  for subdir in "${SUBDIRS[@]}"; do
    link="$repo_dir/docs/$subdir"
    if [ -L "$link" ] && [ -d "$link" ]; then
      ok "$repo/docs/$subdir"
    elif [ -L "$link" ]; then
      fail "$repo/docs/$subdir is a broken symlink" "run: just link"
    else
      fail "$repo/docs/$subdir missing" "run: just link"
    fi
  done
done

# ── Runtimes ───────────────────────────────────────────────────────────────────
echo ""
echo "── Runtimes ──"

# just
if command -v just &>/dev/null; then
  ok "just $(just --version 2>/dev/null | head -1)"
else
  fail "just not found" "install: brew install just  or  https://just.systems/man/en/installation.html"
fi

# Python
if command -v python3 &>/dev/null; then
  py_version="$(python3 --version 2>&1 | awk '{print $2}')"
  py_major="$(echo "$py_version" | cut -d. -f1)"
  py_minor="$(echo "$py_version" | cut -d. -f2)"
  if [ "$py_major" -ge 3 ] && [ "$py_minor" -ge 13 ]; then
    ok "Python $py_version"
  else
    fail "Python $py_version (need 3.13+)" "install Python 3.13 via pyenv or system package manager"
  fi
else
  fail "Python not found" "install Python 3.13+"
fi

# uv
if command -v uv &>/dev/null; then
  ok "uv $(uv --version 2>/dev/null)"
else
  fail "uv not found" "install: curl -LsSf https://astral.sh/uv/install.sh | sh"
fi

# Bun
if command -v bun &>/dev/null; then
  ok "bun $(bun --version 2>/dev/null)"
else
  fail "bun not found" "install: curl -fsSL https://bun.sh/install | bash"
fi

# gcloud
if command -v gcloud &>/dev/null; then
  ok "gcloud $(gcloud --version 2>/dev/null | head -1)"
else
  warn "gcloud not found" "needed for GCP deployment — https://cloud.google.com/sdk/docs/install"
fi

# ── Services ───────────────────────────────────────────────────────────────────
echo ""
echo "── Services ──"

# Postgres
if command -v pg_isready &>/dev/null && pg_isready -q 2>/dev/null; then
  ok "Postgres reachable"
else
  warn "Postgres not reachable" "start with: brew services start postgresql  or  pg_ctlcluster start"
fi

# Redis
if command -v redis-cli &>/dev/null && redis-cli ping &>/dev/null; then
  ok "Redis reachable"
else
  warn "Redis not reachable" "start with: brew services start redis  or  redis-server --daemonize yes"
fi

# ── Git ────────────────────────────────────────────────────────────────────────
echo ""
echo "── Git ──"

git_name="$(git config --global user.name 2>/dev/null || true)"
git_email="$(git config --global user.email 2>/dev/null || true)"

if [ -n "$git_name" ]; then
  ok "git user.name: $git_name"
else
  fail "git user.name not set" "run: git config --global user.name 'Your Name'"
fi

if [ -n "$git_email" ]; then
  ok "git user.email: $git_email"
else
  fail "git user.email not set" "run: git config --global user.email 'you@example.com'"
fi

# ── Environment ────────────────────────────────────────────────────────────────
echo ""
echo "── Environment ──"

check_env() {
  local var="$1"
  local repo="$2"
  if [ -n "${!var:-}" ]; then
    ok "$var set"
  else
    warn "$var not set" "add to $repo/.envrc"
  fi
}

check_env GOOGLE_ADK_API_KEY "dime"
check_env LOGFIRE_TOKEN "dime"
check_env DATABASE_URL "dime"
check_env REDIS_URL "dime"

# ── Summary ────────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────"
echo "  ✓ $pass passed   ✗ $fail failed   ⚑ $warn warnings"
echo "────────────────────────────────────"
echo ""

if [ "$fail" -gt 0 ]; then
  echo "Fix failures before starting development."
  exit 1
elif [ "$warn" -gt 0 ]; then
  echo "Warnings are non-blocking but should be resolved before integration tests."
  exit 0
else
  echo "All checks passed. Ready to develop."
  exit 0
fi
