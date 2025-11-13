#!/usr/bin/env bash
set -e

current_tag="$1"
previous_tag="$2"

# Detect current tag
if [ -z "$current_tag" ]; then
  current_tag="${GITHUB_REF_NAME:-}"
fi

if [ -z "$current_tag" ]; then
  echo "❌ ERROR: No current tag provided and no release event found"
  exit 1
fi

echo "current_tag=$current_tag" >> "$GITHUB_OUTPUT"
echo "Current tag: $current_tag"

# Verify current tag exists
if ! git rev-parse "$current_tag" >/dev/null 2>&1; then
  echo "❌ ERROR: Tag '$current_tag' does not exist"
  exit 1
fi

# Determine previous tag
if [ -z "$previous_tag" ]; then
  git fetch --tags --force
  previous_tag=$(git tag --sort=-creatordate | grep -v "^${current_tag}$" | head -n1)

  if [ -z "$previous_tag" ]; then
    echo "⚠️ No previous tag found, using first commit"
    previous_tag=$(git rev-list --max-parents=0 HEAD)
  fi
else
  if ! git rev-parse "$previous_tag" >/dev/null 2>&1; then
    echo "❌ ERROR: Provided previous tag '$previous_tag' does not exist"
    exit 1
  fi
fi

echo "prev_tag=$previous_tag" >> "$GITHUB_OUTPUT"
echo "Previous tag: $previous_tag"

# Validate diffability
if ! git diff --name-only "$previous_tag" "$current_tag" >/dev/null 2>&1; then
  echo "❌ ERROR: Cannot compare $previous_tag and $current_tag"
  exit 1
fi
