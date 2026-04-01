#!/usr/bin/env bash
# Creates symlinks in sibling repos pointing to dime-ops/docs/.
# Safe to run multiple times — updates stale links, skips current ones,
# warns on conflicts.

set -euo pipefail

DIME_OPS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "$DIME_OPS_DIR")"

REPOS=("dime" "dime-ui" "acts-of-defiance" "compendium")
SUBDIRS=("memory" "specs" "decisions" "wireframes" "issues" "projects")

# Claude Code skill to link per repo (filename in dime-ops/.claude/commands/)
# Uses a case statement for Bash 3.2 compatibility (macOS default shell).
get_skill_file() {
  case "$1" in
    "dime")           echo "feature-dime.md" ;;
    "dime-ui")        echo "feature-dime-ui.md" ;;
    "acts-of-defiance") echo "feature-aod.md" ;;
    *)                echo "" ;;
  esac
}

ok=0; skipped=0; updated=0; warned=0

create_symlink() {
  local target="$1"
  local link="$2"

  mkdir -p "$(dirname "$link")"

  if [ -L "$link" ]; then
    local current_target
    current_target="$(readlink "$link")"
    if [ "$current_target" = "$target" ]; then
      echo "  ✓ $link"
      ((ok++)) || true
      return
    else
      rm "$link"
      ln -s "$target" "$link"
      echo "  ↺ updated: $link"
      ((updated++)) || true
    fi
  elif [ -e "$link" ]; then
    echo "  ⚑ SKIP: $link exists and is not a symlink — remove it manually to link"
    ((warned++)) || true
  else
    ln -s "$target" "$link"
    echo "  ✓ linked: $link"
    ((ok++)) || true
  fi
}

ensure_claudeignore() {
  local repo_dir="$1"
  local dest="$repo_dir/.claudeignore"
  if [ ! -f "$dest" ]; then
    cp "$DIME_OPS_DIR/.claudeignore" "$dest"
    echo "  ✓ .claudeignore created"
  else
    echo "  ✓ .claudeignore exists"
  fi
}

echo "dime-ops: $DIME_OPS_DIR"
echo "siblings: $PARENT_DIR"
echo ""

for repo in "${REPOS[@]}"; do
  repo_dir="$PARENT_DIR/$repo"
  if [ ! -d "$repo_dir" ]; then
    echo "── $repo ── (not found, skipping)"
    ((skipped++)) || true
    echo ""
    continue
  fi

  echo "── $repo ──"
  for subdir in "${SUBDIRS[@]}"; do
    create_symlink "$DIME_OPS_DIR/docs/$subdir" "$repo_dir/docs/$subdir"
  done
  ensure_claudeignore "$repo_dir"
  skill_file=$(get_skill_file "$repo")
  if [ -n "$skill_file" ]; then
    create_symlink "$DIME_OPS_DIR/.claude/commands/$skill_file" "$repo_dir/.claude/commands/$skill_file"
  fi
  create_symlink "$DIME_OPS_DIR/.claude/tools" "$repo_dir/.claude/tools"
  echo ""
done

echo "Done. ✓ $ok linked  ↺ $updated updated  ⚑ $warned warnings  $skipped repos skipped"
echo "Run 'just doctor' to verify the full setup."
