# Changelog Generator

A Claude Code skill that generates a structured `CHANGELOG.md` from your project's git history.

## Setup

1. Place `skills/changelog/` into your project's `.claude/skills/` directory
2. Run `/generate-changelog` or `bash changelog.sh`
3. Review the generated `CHANGELOG.md`

## How It Works

The tool fetches commits since the last git tag and auto-categorizes them by type:

| Category   | Conventional Commit Prefix |
|-----------|---------------------------|
| **Added** | `feat:`                    |
| **Fixed** | `fix:`                     |
| **Changed** | `chore:`, `refactor:`, `perf:`, `style:` |
| **Removed** | `revert:`                  |

If no conventional commit prefixes are found, all commits are listed chronologically.

## Sample

See [`sample/CHANGELOG.md`](sample/CHANGELOG.md) for example output.

## Requirements

- `git` (installed)
- Bash or Python 3 (if using the Python variant)
