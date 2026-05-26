#!/usr/bin/env bash
# changelog.sh — Generate a structured CHANGELOG.md from git history
# Usage: bash changelog.sh [output_file]
# Default output: CHANGELOG.md

set -euo pipefail

OUTPUT="${1:-CHANGELOG.md}"

# Check we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not a git repository" >&2
    exit 1
fi

# Get the last tag (if any)
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

echo "Generating changelog from git history..."

if [ -n "$LAST_TAG" ]; then
    echo "Using commits since tag: $LAST_TAG"
    RANGE="${LAST_TAG}..HEAD"
else
    echo "No tags found — using all commits"
    RANGE="HEAD"
fi

# Get the repo name from remote or directory
REPO_NAME=$(git remote get-url origin 2>/dev/null | sed 's/.*[/:]//' | sed 's/\.git$//')
[ -z "$REPO_NAME" ] && REPO_NAME=$(basename "$(pwd)")

# Get current date
DATE=$(date +%Y-%m-%d)

# Start writing changelog
cat > "$OUTPUT" << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

EOF

# Categorize commits
categorize_commits() {
    local category="$1"
    local pattern="$2"

    commits=$(git log "$RANGE" --oneline --grep="$pattern" 2>/dev/null | head -20)
    if [ -n "$commits" ]; then
        echo "### $category" >> "$OUTPUT"
        echo "" >> "$OUTPUT"

        # Process each commit, stripping the prefix
        git log "$RANGE" --format="%s" --grep="$pattern" 2>/dev/null | head -20 | while IFS= read -r msg; do
            # Remove the prefix (e.g., "feat: ", "feat(some): ", "FIX: ")
            clean=$(echo "$msg" | sed -E 's/^(feat|fix|chore|docs|refactor|style|test|perf|build|ci|revert)(\([^)]*\))?:\s*//i')
            sha=$(git log "$RANGE" --format="%h" --grep="$msg" 2>/dev/null | head -1)
            if [ -n "$clean" ]; then
                echo "- $clean ([$sha](https://github.com/$REPO_NAME/commit/$sha))" >> "$OUTPUT"
            fi
        done
        echo "" >> "$OUTPUT"
    fi
}

# Process each conventional commit category
categorize_commits "Added" "^feat"
categorize_commits "Fixed" "^fix"
categorize_commits "Changed" "^(chore|refactor|perf|style)"
categorize_commits "Removed" "^revert"

# If we have no categorized commits, just list all
LINE_COUNT=$(wc -l < "$OUTPUT")
if [ "$LINE_COUNT" -le 4 ]; then
    echo "No conventional commits found — listing all commits..."
    cat > "$OUTPUT" << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

EOF
    git log "$RANGE" --format="- %s ([%h](https://github.com/$REPO_NAME/commit/%h))" 2>/dev/null | head -30 >> "$OUTPUT"
    printf "
" >> "$OUTPUT"
fi

echo "✅ Changelog written to $(pwd)/$OUTPUT"
