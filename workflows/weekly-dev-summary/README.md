# Weekly Dev Summary — n8n + Claude

An n8n workflow that automatically generates a narrative weekly summary of GitHub repo activity using the Claude API.

## Features

- **Weekly cron** (Friday 5PM, configurable)
- **Fetches**: commits, merged PRs, closed issues via GitHub API
- **Claude API** (`claude-sonnet-4-20250514`) generates a narrative summary
- **Multi-language**: English (EN) or French (FR)
- **Delivery**: Discord webhook, Slack webhook, or email
- **Configurable**: GitHub repo, webhook URL, language

## Installation (5 steps)

1. **Import the workflow** in n8n:
   - Go to **Workflows → Add Workflow → Import from File**
   - Select `weekly-dev-summary.json`

2. **Add GitHub credentials**:
   - Create a [GitHub personal access token](https://github.com/settings/tokens)
   - In n8n, add a **GitHub API** credential with your token
   - The HTTP Request nodes use `credentialType: gitHubApi` — select your credential

3. **Add Claude API key**:
   - Set environment variable: `ANTHROPIC_API_KEY=sk-ant-...`
   - Or add it in n8n's **Variables** as `ANTHROPIC_API_KEY`

4. **Configure delivery**:
   - Create a **Discord webhook** (Channel → Edit → Integrations → Webhook) or **Slack webhook**
   - Set webhook URL via env var or n8n variable:
     - `DISCORD_WEBHOOK_URL` or `SLACK_WEBHOOK_URL`

5. **Activate the workflow**:
   - Click **Active** toggle in the top-right corner

## Configuration

### Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `ANTHROPIC_API_KEY` | ✅ Yes | — | Claude API key |
| `GITHUB_REPO` | No | `owner/repo` | GitHub repo to monitor |
| `DISCORD_WEBHOOK_URL` | No* | — | Discord webhook URL |
| `SLACK_WEBHOOK_URL` | No* | — | Slack webhook URL |

\* At least one webhook URL is required.

### Workflow Config (via initial trigger or n8n variables)

- **`repo`**: GitHub repo (format: `owner/repo`)
- **`language`**: `EN` (default) or `FR`
- **`delivery_method`**: `discord` (default), `slack`, or `email`

## Sample Output

> 📊 **This week: 12 commits, 5 PRs merged, 3 issues closed. Contributors: alice, bob**
>
> ### 🚀 What's New
> This was a productive week for the repo! Alice landed the authentication refactor (PR #123) that reduces login latency by 40%. Bob shipped the dashboard v2 with real-time metrics...
>
> ### 🐛 Bug Fixes
> Three regression bugs were fixed, including the edge case where session timeouts weren't being handled correctly in the mobile web view...
>
> 🤖 *Weekly Dev Summary by n8n + Claude*

## Requirements

- n8n (self-hosted or cloud, v1.0+)
- GitHub personal access token
- Anthropic API key (Claude)
- Discord or Slack webhook URL
