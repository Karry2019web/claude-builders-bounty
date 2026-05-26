---
name: changelog-generator
description: Generate a structured CHANGELOG.md from git history
author: Karry2019web
version: 1.0.0
---

# Changelog Generator

A skill that automatically generates a structured `CHANGELOG.md` from a project's git history.

## Usage

Run the command:

```
/generate-changelog
```

Or use the bash script directly:

```bash
bash changelog.sh
```

A sample output `CHANGELOG.md` will be written to the current directory.

## What It Does

- Fetches commits since the last git tag (or all commits if no tags exist)
- Auto-categorizes commits into: `Added` / `Fixed` / `Changed` / `Removed`
- Outputs a properly formatted `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/) format
- Works on any Git repository

## Requirements

- `git` installed and available in PATH
- A Git repository with commit history
- Bash or Python 3

## Integration

This skill can be added to your Claude Code project as a custom skill. Place `SKILL.md` and `changelog.sh` in your project's `.claude/skills/` directory.
