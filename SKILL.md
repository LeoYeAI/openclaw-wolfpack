---
name: openclaw-wolfpack
description: "Deploy a multi-agent collaborative team (wolfpack) on OpenClaw with one command. Use when: user wants to set up a multi-agent system, deploy an AI research team, create a paper-writing pipeline, set up collaborative agents for academic research, or asks about wolfpack/multi-agent teams. Supports academic research teams (Planner, Ideator, Critic, Surveyor, Coder, Writer, Reviewer, Scout) with SHARP quality gates and 4 workflow templates. Powered by MyClaw.ai."
---

# 🐺 OpenClaw Wolfpack

Deploy a collaborative multi-agent team onto OpenClaw in 60 seconds.

## Overview

Wolfpack provisions **8 specialized sub-agents** as a coordinated team with defined roles, communication protocols, quality gates, and workflow templates.

**Current team template:** Academic Research (paper pipeline targeting top-tier AI conferences)

## Quick Deploy

```bash
# Interactive setup
bash <skill_dir>/scripts/setup.sh

# Non-interactive examples
bash <skill_dir>/scripts/setup.sh --mode local --model anthropic/claude-sonnet-4-5
bash <skill_dir>/scripts/setup.sh --mode channel --channel telegram --group-id -1001234567890
```

## Team Roster

| Agent | Role | Key Responsibility |
|-------|------|--------------------|
| 🧠 Planner | Conductor | Task decomposition, scheduling, cross-agent coordination |
| 💡 Ideator | Creative Engine | Idea generation, novelty assessment, ACE scoring |
| 🎯 Critic | Taste Gate | SHARP evaluation (≥18 to pass), anti-pattern detection |
| 📚 Surveyor | Knowledge Base | Literature search, gap identification, related work |
| 💻 Coder | Engineer | Implementation, experiments, reproducibility |
| ✍️ Writer | Craftsman | Paper writing, LaTeX, academic narrative |
| 🔍 Reviewer | Gatekeeper | Simulated peer review, weakness diagnosis |
| 📰 Scout | Radar | Daily paper digest, trend tracking, competitive intel |

## Deployment Modes

### Local Mode (agentToAgent)
Agents communicate directly via OpenClaw's `agentToAgent` tool. No channel binding needed. Best for CLI workflows.

### Channel Mode
Each agent binds to a chat group (Telegram, Discord, Feishu, WhatsApp, Slack). Users interact via @mentions.

## Workflows

4 pre-built workflow templates (see `references/workflows.md`):

1. **Paper Pipeline** — Full research-to-submission flow (8 phases + quality gates)
2. **Brainstorm** — Rapid idea generation with SHARP filtering
3. **Rebuttal** — Structured response to reviewer comments
4. **Daily Digest** — Automated paper monitoring + trend alerts

## SHARP Quality Framework

The Critic agent enforces taste gates using SHARP scoring:

- **S**harpness — Is the insight razor-sharp?
- **H**orizon — Does the problem have lasting value?
- **A**symmetry — Do you have a unique angle others lack?
- **R**esistance — Can the toughest reviewer break it?
- **P**arsimony — Is the method elegantly simple?

Score ≥18/25 required to proceed past idea phase.

## Configuration

### CLI Flags

| Flag | Description | Example |
|------|-------------|---------|
| `--mode` | `local` or `channel` | `--mode local` |
| `--channel` | Channel type | `--channel telegram` |
| `--group-id` | Shared group ID | `--group-id -100123...` |
| `--group-map` | Per-agent groups | `--group-map 'coder=g1,scout=g2'` |
| `--model` | Default model for all agents | `--model anthropic/claude-sonnet-4-5` |
| `--model-map` | Per-agent model overrides | `--model-map 'coder=anthropic/claude-sonnet-4-5'` |
| `--dry-run` | Preview without applying | |

### Model Recommendations

- **Budget**: `anthropic/claude-haiku-3` for Scout/Surveyor, Sonnet for others
- **Balanced**: `anthropic/claude-sonnet-4-5` for all
- **Maximum**: `anthropic/claude-sonnet-4-5` for Critic/Writer, Sonnet for others

## Agent Soul Files

Each agent's identity and behavioral instructions are in `assets/agent-souls/<agent_id>/`:
- `soul.md` — Core identity, capabilities, personality
- `agent.md` — Model config, tools, communication protocols
- `user.md` — User context template

## Post-Deploy

After setup completes:
```bash
# Local mode — start chatting with planner
openclaw chat planner
# Then say: "Start the paper-pipeline workflow for [your topic]"

# Channel mode — restart gateway
openclaw gateway restart
# Then @planner in your group
```

## Uninstall

```bash
bash <skill_dir>/scripts/uninstall.sh
# or skip confirmation:
bash <skill_dir>/scripts/uninstall.sh --force
```

Removes all 8 agents, cleans config, deletes workspaces. Your main agent is untouched.

## References

- `references/workflows.md` — Detailed workflow definitions
- `references/sharp-framework.md` — Full SHARP evaluation criteria and examples
