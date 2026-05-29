#!/usr/bin/env bash

set -euo pipefail

LAST_SYNC_SHA="${1:-}"
CURRENT_UPSTREAM_SHA="${2:-}"
UPSTREAM_REPO="${3:-}"
UPSTREAM_BRANCH="${4:-main}"

if [ -z "${CURRENT_UPSTREAM_SHA}" ] || [ -z "${UPSTREAM_REPO}" ]; then
  echo "Usage: $0 <last_sync_sha> <current_upstream_sha> <upstream_repo> [upstream_branch]" >&2
  exit 1
fi

SYNC_DATE="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

EMPTY_TREE="4b825dc642cb6eb9a060e54bf8d69288fbee4904"

# --------------------------------------------------
# Build ranges
# --------------------------------------------------

if [ -n "${LAST_SYNC_SHA}" ]; then
  DIFF_RANGE="${LAST_SYNC_SHA}..${CURRENT_UPSTREAM_SHA}"
  COMMITS_RANGE="${DIFF_RANGE}"

  COMPARE_URL="https://github.com/${UPSTREAM_REPO}/compare/${LAST_SYNC_SHA}...${CURRENT_UPSTREAM_SHA}"

  PREVIOUS_SHA_DISPLAY="\`${LAST_SYNC_SHA}\`"
else
  DIFF_RANGE="${EMPTY_TREE}..${CURRENT_UPSTREAM_SHA}"
  COMMITS_RANGE="${CURRENT_UPSTREAM_SHA}"

  COMPARE_URL="Initial synchronization from upstream branch \`${UPSTREAM_BRANCH}\` (no previous upstream state)"

  PREVIOUS_SHA_DISPLAY="none (first sync)"
fi

# --------------------------------------------------
# Commit list
# --------------------------------------------------

COMMITS="$(
  git log \
    --reverse \
    --pretty=format:'- %s (`%h`) — %an' \
    "${COMMITS_RANGE}" \
    2>/dev/null || true
)"

# --------------------------------------------------
# Changed files
# --------------------------------------------------

FILES="$(
  git diff --name-only "${DIFF_RANGE}" \
    | sed 's/^/- /' \
    2>/dev/null || true
)"

# --------------------------------------------------
# Statistics
# --------------------------------------------------

STATS="$(
  git diff --shortstat "${DIFF_RANGE}" \
    2>/dev/null || true
)"

# --------------------------------------------------
# Authors
# --------------------------------------------------

AUTHORS="$(
  git log \
    --format='%an' \
    "${COMMITS_RANGE}" \
    2>/dev/null \
    | sort -u \
    | sed 's/^/- /' || true
)"

# --------------------------------------------------
# Output
# --------------------------------------------------

cat <<EOF

## Upstream synchronization

This PR synchronizes changes from upstream.

### Synchronization date

${SYNC_DATE}

### Sync information

- Upstream repository: \`${UPSTREAM_REPO}\`
- Upstream branch: \`${UPSTREAM_BRANCH}\`
- Previous upstream SHA: ${PREVIOUS_SHA_DISPLAY}
- Current upstream SHA: \`${CURRENT_UPSTREAM_SHA}\`

### Statistics

${STATS:-No changes detected}

### Upstream compare

${COMPARE_URL}

### Authors

${AUTHORS:-Unknown}

### Included commits

${COMMITS:-No commits found}

### Changed files

${FILES:-No file changes}

EOF