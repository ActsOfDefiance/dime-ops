#!/usr/bin/env bash
# Usage: pr-poll.sh <owner/repo> <pr_number> [--check]
#
# Polls for PR review activity every 60s until unresolved threads or new activity
# is detected. Outputs activity details and exits.
#
# Modes:
#   (default)  Poll until new unresolved activity appears, then exit.
#   --check    One-shot: print unresolved threads and exit immediately.
#
# Exit codes:
#   0  Unresolved threads found (or activity detected)
#   1  Error
#   2  No unresolved threads (--check mode only)

set -euo pipefail
REPO="${1:?Usage: pr-poll.sh <owner/repo> <pr_number> [--check]}"
PR="${2:?Usage: pr-poll.sh <owner/repo> <pr_number> [--check]}"
MODE="${3:-poll}"

OWNER="${REPO%%/*}"
NAME="${REPO##*/}"

# Verify dependencies
if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI not found. Install from https://cli.github.com/" >&2; exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
  echo "Error: gh is not authenticated. Run 'gh auth login' first." >&2; exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq not found. Install from https://jqlang.github.io/jq/" >&2; exit 1
fi

# Portable hashing: prefer md5sum (Linux), fall back to md5 (macOS).
if command -v md5sum >/dev/null 2>&1; then
  HASH_CMD="md5sum"
elif command -v md5 >/dev/null 2>&1; then
  HASH_CMD="md5"
else
  echo "Error: neither md5sum nor md5 found" >&2; exit 1
fi

compute_hash() {
  $HASH_CMD | grep -oE '[a-f0-9]{32}'
}

# ---------------------------------------------------------------------------
# Unresolved thread detection (GraphQL)
# ---------------------------------------------------------------------------

fetch_unresolved_threads() {
  gh api graphql -f query="
    query {
      repository(owner: \"$OWNER\", name: \"$NAME\") {
        pullRequest(number: $PR) {
          reviewThreads(first: 50) {
            nodes {
              id
              isResolved
              comments(first: 5) {
                nodes {
                  body
                  author { login }
                  path
                  line
                  createdAt
                }
              }
            }
          }
        }
      }
    }
  "
}

print_unresolved_threads() {
  local json="$1"
  local threads
  threads=$(echo "$json" | jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)]')
  local count
  count=$(echo "$threads" | jq 'length')

  if [ "$count" -eq 0 ]; then
    echo "No unresolved review threads."
    return 1
  fi

  echo "=== UNRESOLVED REVIEW THREADS ($count) ==="
  echo "$threads" | jq -r '.[] |
    "Thread: \(.id)\n" +
    "  \(.comments.nodes[0].author.login) — \(.comments.nodes[0].path):\(.comments.nodes[0].line // "general")\n" +
    "  \(.comments.nodes[0].body[0:500])\n" +
    (if (.comments.nodes | length) > 1 then
      "  + \((.comments.nodes | length) - 1) more comment(s)\n"
    else "" end)
  '
  return 0
}

get_unresolved_count() {
  local json="$1"
  echo "$json" | jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] | length'
}

# ---------------------------------------------------------------------------
# --check mode: one-shot, print unresolved threads and exit
# ---------------------------------------------------------------------------

if [ "$MODE" = "--check" ]; then
  thread_json=$(fetch_unresolved_threads)
  if print_unresolved_threads "$thread_json"; then
    # Also show approval status
    review_json=$(gh api --paginate "repos/$REPO/pulls/$PR/reviews" | jq -s 'add // []')
    approved=$(echo "$review_json" | jq '
      group_by(.user.login)
      | map(sort_by(.submitted_at) | .[-1])
      | map(select(.state == "APPROVED"))
      | length
    ')
    changes_requested=$(echo "$review_json" | jq '
      group_by(.user.login)
      | map(sort_by(.submitted_at) | .[-1])
      | map(select(.state == "CHANGES_REQUESTED"))
      | length
    ')
    echo "=== Approvals: $approved | Changes requested: $changes_requested ==="
    exit 0
  else
    echo "=== All threads resolved ==="
    exit 2
  fi
fi

# ---------------------------------------------------------------------------
# Helpers: print activity from cached JSON (no extra API calls)
# ---------------------------------------------------------------------------

print_new_issue_comments() {
  local json="$1"
  echo "=== NEW ISSUE COMMENT(S) ==="
  echo "$json" | jq -r '.[] | "--- \(.user.login) (\(.created_at)) ---\n\((.body // "")[0:500])\n"'
}

print_new_reviews() {
  local json="$1" label="$2"
  echo "=== $label ==="
  echo "$json" | jq -r '.[] | "--- \(.user.login) (\(.submitted_at)) [state: \(.state)] ---\n\((.body // "")[0:500])\n"'
}

print_new_line_comments() {
  local json="$1" label="$2"
  echo "=== $label ==="
  echo "$json" | jq -r '.[] | "--- \(.user.login) (\(.created_at)) [path: \(.path):\(.line)] ---\n\((.body // "")[0:500])\n"'
}

# ---------------------------------------------------------------------------
# State variables for change detection
# ---------------------------------------------------------------------------

LAST_COMMENTS=0
LAST_REVIEWS=0
LAST_LINE_COMMENTS=0
LAST_REVIEW_HASH="0"
LAST_LC_HASH="0"
LAST_ISSUE_HASH="0"
CURRENT_APPROVED=0
CURRENT_CC=0
CURRENT_RC=0
CURRENT_LC=0

# ---------------------------------------------------------------------------
# Check for activity, printing and updating state variables.
# Sets CHANGED=true if anything fired. Exposes CURRENT_APPROVED.
# ---------------------------------------------------------------------------

check_activity() {
  local review_label="${1:-NEW/UPDATED REVIEW(S)}"
  local lc_label="${2:-NEW/UPDATED LINE COMMENT(S)}"

  local issue_json review_json lc_json cc rc lc issue_hash review_hash lc_hash
  issue_json=$(gh api --paginate "repos/$REPO/issues/$PR/comments" | jq -s 'add // []')
  review_json=$(gh api --paginate "repos/$REPO/pulls/$PR/reviews" | jq -s 'add // []')
  lc_json=$(gh api --paginate "repos/$REPO/pulls/$PR/comments" | jq -s 'add // []')
  cc=$(echo "$issue_json" | jq 'length')
  rc=$(echo "$review_json" | jq 'length')
  lc=$(echo "$lc_json" | jq 'length')
  issue_hash=$(echo "$issue_json" \
    | jq -r '[.[] | .created_at + .updated_at + ((.body // "")[0:100])] | join("|")' | compute_hash)
  review_hash=$(echo "$review_json" \
    | jq -r '[.[] | .submitted_at + .state + ((.body // "")[0:100])] | join("|")' | compute_hash)
  lc_hash=$(echo "$lc_json" \
    | jq -r '[.[] | .created_at + .updated_at + ((.body // "")[0:100])] | join("|")' | compute_hash)

  CHANGED=false

  if [ "$cc" -gt "$LAST_COMMENTS" ] || [ "$issue_hash" != "$LAST_ISSUE_HASH" ]; then
    print_new_issue_comments "$issue_json"
    LAST_COMMENTS=$cc; LAST_ISSUE_HASH=$issue_hash; CHANGED=true
  fi

  if [ "$rc" -gt "$LAST_REVIEWS" ] || [ "$review_hash" != "$LAST_REVIEW_HASH" ]; then
    print_new_reviews "$review_json" "$review_label"
    LAST_REVIEWS=$rc; LAST_REVIEW_HASH=$review_hash; CHANGED=true
  fi

  if [ "$lc" -gt "$LAST_LINE_COMMENTS" ] || [ "$lc_hash" != "$LAST_LC_HASH" ]; then
    print_new_line_comments "$lc_json" "$lc_label"
    LAST_LINE_COMMENTS=$lc; LAST_LC_HASH=$lc_hash; CHANGED=true
  fi

  CURRENT_CC=$cc; CURRENT_RC=$rc; CURRENT_LC=$lc
  CURRENT_APPROVED=$(echo "$review_json" | jq '
    group_by(.user.login)
    | map(sort_by(.submitted_at) | .[-1])
    | map(select(.state == "APPROVED"))
    | length
  ')
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------

# First: check for existing unresolved threads before establishing baseline
echo "Checking for unresolved review threads..."
thread_json=$(fetch_unresolved_threads)
unresolved_count=$(get_unresolved_count "$thread_json")

if [ "$unresolved_count" -gt 0 ]; then
  print_unresolved_threads "$thread_json"
  echo "=== Unresolved threads: $unresolved_count ==="
  echo "=== ACTION_NEEDED ==="
  exit 0
fi

# No unresolved threads — establish baseline and poll for new activity
echo "No unresolved threads. Establishing baseline..."
check_activity
echo "Baseline: $CURRENT_CC comments, $CURRENT_RC reviews, $CURRENT_LC line comments"
echo "Watching for new activity..."

while true; do
  sleep 60

  # Check unresolved threads first (may have been added since baseline)
  thread_json=$(fetch_unresolved_threads)
  unresolved_count=$(get_unresolved_count "$thread_json")

  if [ "$unresolved_count" -gt 0 ]; then
    echo "Unresolved threads detected!"
    print_unresolved_threads "$thread_json"
    echo "=== Unresolved threads: $unresolved_count ==="
    echo "=== ACTION_NEEDED ==="
    break
  fi

  # Also check for new comments/reviews/approvals
  check_activity

  if [ "$CHANGED" = "true" ]; then
    echo "Activity detected — waiting 90s for trailing comments..."
    sleep 90
    check_activity "NEW REVIEW(S)" "NEW LINE COMMENT(S)"

    # Re-check threads after trailing wait
    thread_json=$(fetch_unresolved_threads)
    unresolved_count=$(get_unresolved_count "$thread_json")
    if [ "$unresolved_count" -gt 0 ]; then
      print_unresolved_threads "$thread_json"
    fi

    echo "=== Approval count: $CURRENT_APPROVED ==="
    echo "=== Unresolved threads: $unresolved_count ==="
    if [ "$unresolved_count" -gt 0 ]; then
      echo "=== ACTION_NEEDED ==="
    else
      echo "=== APPROVED ==="
    fi
    break
  fi

  echo "$(date '+%H:%M:%S') - No new activity ($CURRENT_CC comments, $CURRENT_RC reviews, $CURRENT_LC line comments, $unresolved_count unresolved)"
done
