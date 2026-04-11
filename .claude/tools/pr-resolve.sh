#!/usr/bin/env bash
# Usage: pr-resolve.sh <owner/repo> <pr_number> <thread_id> <reply_body>
# Replies to a review thread and marks it as resolved.
#
# To list unresolved threads (with IDs), run:
#   pr-poll.sh <owner/repo> <pr_number> --check
#
# Example:
#   pr-resolve.sh ActsOfDefiance/dime 25 PRRT_kwDOxyz "Fixed in abc123"

set -euo pipefail
REPO="${1:?Usage: pr-resolve.sh <owner/repo> <pr_number> <thread_id> <reply_body>}"
PR="${2:?Usage: pr-resolve.sh <owner/repo> <pr_number> <thread_id> <reply_body>}"
THREAD_ID="${3:?Usage: pr-resolve.sh <owner/repo> <pr_number> <thread_id> <reply_body>}"
REPLY_BODY="${4:?Usage: pr-resolve.sh <owner/repo> <pr_number> <thread_id> <reply_body>}"

if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh CLI not found." >&2; exit 1
fi

OWNER="${REPO%%/*}"
NAME="${REPO##*/}"

# Get the pull request node ID
PR_NODE_ID=$(gh api graphql -f query="
  query {
    repository(owner: \"$OWNER\", name: \"$NAME\") {
      pullRequest(number: $PR) { id }
    }
  }
" --jq '.data.repository.pullRequest.id')

if [ -z "$PR_NODE_ID" ]; then
  echo "Error: could not find PR #$PR in $REPO" >&2; exit 1
fi

# Get the first comment ID in this thread (needed for addPullRequestReviewThreadReply)
COMMENT_ID=$(gh api graphql -f query="
  query {
    node(id: \"$THREAD_ID\") {
      ... on PullRequestReviewThread {
        comments(first: 1) {
          nodes { id }
        }
      }
    }
  }
" --jq '.data.node.comments.nodes[0].id')

if [ -z "$COMMENT_ID" ]; then
  echo "Error: could not find comment in thread $THREAD_ID" >&2; exit 1
fi

# Reply to the thread
echo "Replying to thread $THREAD_ID..."
gh api graphql -f query="
  mutation {
    addPullRequestReviewThreadReply(input: {
      pullRequestReviewThreadId: \"$THREAD_ID\"
      body: \"$(echo "$REPLY_BODY" | sed 's/"/\\"/g; s/$/\\n/' | tr -d '\n' | sed 's/\\n$//')\"
    }) {
      comment { id url }
    }
  }
" --jq '.data.addPullRequestReviewThreadReply.comment.url'

# Resolve the thread
echo "Resolving thread $THREAD_ID..."
gh api graphql -f query="
  mutation {
    resolveReviewThread(input: {
      threadId: \"$THREAD_ID\"
    }) {
      thread { isResolved }
    }
  }
" --jq '.data.resolveReviewThread.thread.isResolved' | xargs -I{} echo "Resolved: {}"

echo "Done."
