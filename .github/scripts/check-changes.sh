#!/usr/bin/env bash
set -e

base_ref="$1"
head_ref="$2"
watched_files_input="$3"

echo "=========================================="
echo "Checking file changes from $base_ref → $head_ref"
echo "=========================================="

# Collect changed files
if ! changed_files=$(git diff --name-only "$base_ref" "$head_ref" 2>&1); then
  echo "❌ ERROR: Failed to get changed files"
  echo "$changed_files"
  exit 1
fi

echo "Changed files in release:"
if [ -z "$changed_files" ]; then
  echo "  (none)"
else
  echo "$changed_files" | sed 's/^/  /'
fi
echo ""

# Normalize watched files
watched_files=$(echo "$watched_files_input" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep -v '^$')

echo "Watching files:"
echo "$watched_files" | sed 's/^/  /'
echo ""

files_changed="false"
changed_files_list=""

while IFS= read -r watched_file; do
  [ -z "$watched_file" ] && continue

if echo "$changed_files" | grep -E -q "$(echo "$watched_file" | sed 's/\./\\./g; s/\*/.*/g; s/\?/./g')"; then
  files_changed="true"
  echo "  ✓ CHANGED: $watched_file"
  changed_files_list="${changed_files_list:+$changed_files_list,}$watched_file"
else
  echo "  ✗ No change: $watched_file"
fi

done <<< "$watched_files"

echo ""
echo "=========================================="
echo "RESULT: files_changed=$files_changed"
echo "=========================================="

echo "files_changed=$files_changed" >> "$GITHUB_OUTPUT"
echo "changed_files_list=$changed_files_list" >> "$GITHUB_OUTPUT"
