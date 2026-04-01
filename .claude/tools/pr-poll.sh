#!/usr/bin/env bash
# Usage: pr-poll.sh <owner/repo> <pr_number>
# Polls for PR review activity every 60s until any new activity is detected.
# Outputs activity details and a final "=== Approval count: N ===" line, then exits.

set -euo pipefail
REPO="${1:?Usage: pr-poll.sh <owner/repo> <pr_number>}"
PR="${2:?Usage: pr-poll.sh <owner/repo> <pr_number>}"

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

# Initialize to zero so any pre-existing activity is detected on the first poll
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
# Helpers: print activity from cached JSON (no extra API calls)
# ---------------------------------------------------------------------------

print_new_issue_comments() {
  local json="$1"
  echo "=== NEW ISSUE COMMENT(S) ==="
  echo "$json" | jq -r '.[] | "--- \(.user.login) (\(.created_at)) ---\n\(.body[:500])\n"'
}

print_new_reviews() {
  local json="$1" label="$2"
  echo "=== $label ==="
  echo "$json" | jq -r '.[] | "--- \(.user.login) (\(.submitted_at)) [state: \(.state)] ---\n\(.body[:500])\n"'
}

print_new_line_comments() {
  local json="$1" label="$2"
  echo "=== $label ==="
  echo "$json" | jq -r '.[] | "--- \(.user.login) (\(.created_at)) [path: \(.path):\(.line)] ---\n\(.body[:500])\n"'
}

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
    | jq -r '[.[] | .created_at + .updated_at + (.body[:100])] | join("|")' | compute_hash)
  review_hash=$(echo "$review_json" \
    | jq -r '[.[] | .submitted_at + .state + (.body[:100])] | join("|")' | compute_hash)
  lc_hash=$(echo "$lc_json" \
    | jq -r '[.[] | .created_at + .updated_at + (.body[:100])] | join("|")' | compute_hash)

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

while true; do
  sleep 60
  check_activity

  if [ "$CHANGED" = "true" ]; then
    echo "Activity detected — waiting 90s for trailing comments..."
    sleep 90
    check_activity "NEW REVIEW(S)" "NEW LINE COMMENT(S)"

    echo "=== Approval count: $CURRENT_APPROVED ==="
    break
  fi

  echo "$(date '+%H:%M:%S') - No new activity ($CURRENT_CC comments, $CURRENT_RC reviews, $CURRENT_LC line comments)"
done
