<p align="center">
  <img src="https://img.shields.io/badge/OpenClaw-Wolfpack-blue?style=for-the-badge" alt="OpenClaw Wolfpack">
  <br/>
  <img src="https://img.shields.io/badge/agents-8-orange?style=flat-square" alt="Agents">
  <img src="https://img.shields.io/badge/workflows-4-green?style=flat-square" alt="Workflows">
  <img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License">
  <a href="https://myclaw.ai"><img src="https://img.shields.io/badge/Powered%20by-MyClaw.ai-ff6b35?style=flat-square" alt="Powered by MyClaw.ai"></a>
</p>

<h1 align="center">🐺 OpenClaw Wolfpack</h1>

<p align="center">
  <strong>Deploy a collaborative AI agent team on <a href="https://docs.openclaw.ai">OpenClaw</a> in 60 seconds.</strong>
</p>

<p align="center">
  <a href="README.md">English</a> •
  <a href="README.zh-CN.md">中文</a> •
  <a href="README.ja.md">日本語</a> •
  <a href="README.fr.md">Français</a> •
  <a href="README.de.md">Deutsch</a> •
  <a href="README.es.md">Español</a> •
  <a href="README.ru.md">Русский</a> •
  <a href="README.it.md">Italiano</a>
</p>

---

## What Is This?

**Wolfpack** is a one-command multi-agent skill for [OpenClaw](https://docs.openclaw.ai). It deploys **8 specialized AI agents** as a coordinated team — complete with identities, quality gates, and workflow templates.

Think of it as deploying an entire AI research lab with one script.

### 🐺 The Pack

| Agent | Role | What It Does |
|-------|------|-------------|
| 🧠 **Planner** | Conductor | Decomposes tasks, tracks progress, coordinates the team |
| 💡 **Ideator** | Creative Engine | Generates research ideas, assesses novelty |
| 🎯 **Critic** | Taste Gate | Evaluates ideas with SHARP framework (score ≥18 to pass) |
| 📚 **Surveyor** | Knowledge Base | Literature search, research gap identification |
| 💻 **Coder** | Engineer | Algorithm implementation, experiment execution |
| ✍️ **Writer** | Craftsman | Academic writing, LaTeX formatting |
| 🔍 **Reviewer** | Gatekeeper | Simulated peer review, weakness diagnosis |
| 📰 **Scout** | Radar | Daily paper digest, trend monitoring |

### 🔥 Key Features

- **One-command deploy** — 8 agents provisioned with a single script
- **SHARP quality gates** — Critic enforces taste standards (no mediocre ideas proceed)
- **Adversarial collaboration** — Ideator↔Critic and Writer↔Reviewer creative tension
- **4 workflow templates** — Paper Pipeline, Brainstorm, Rebuttal, Daily Digest
- **Two deployment modes** — Channel (Telegram/Discord/Feishu/etc.) or Local (CLI)
- **Safe merge** — Appends to existing config, never overwrites your main agent

---

## Quick Start

### Install

```bash
git clone https://github.com/LeoYeAI/openclaw-wolfpack.git
cd openclaw-wolfpack
chmod +x scripts/setup.sh
```

### Deploy

```bash
# Interactive
./scripts/setup.sh

# Local mode (no channel needed)
./scripts/setup.sh --mode local --model anthropic/claude-sonnet-4-5

# Channel mode (e.g., Telegram)
./scripts/setup.sh --mode channel --channel telegram --group-id -1001234567890
```

### Use

```bash
# Local mode
openclaw chat planner
# → "Start the paper-pipeline workflow for multi-agent reasoning efficiency"

# Channel mode
openclaw gateway restart
# → @planner in your group chat
```

---

## Deployment Modes

### Local Mode (agentToAgent)
Agents communicate directly via OpenClaw's internal messaging. No chat platform needed.

```bash
./scripts/setup.sh --mode local
```

### Channel Mode
Each agent binds to a chat group. Interact via @mentions.

```bash
./scripts/setup.sh --mode channel --channel telegram --group-id -1001234567890
```

Supported channels: `telegram` | `discord` | `feishu` | `whatsapp` | `slack`

---

## Workflows

### 📋 Paper Pipeline
Full research-to-submission flow: Survey → Ideation → SHARP Gate → Design → Code → Experiments → Write → Review → Submit

### 💡 Brainstorm
Rapid idea generation session with structured SHARP filtering.

### 🔄 Rebuttal
Coordinated response to reviewer comments with parallel task execution.

### 📰 Daily Digest
Automated paper monitoring with collision warnings and trend analysis.

---

## SHARP Framework

The Critic's quality gate scoring:

| Dimension | Question |
|-----------|----------|
| **S**harpness | Can you explain WHY it works in one sentence? |
| **H**orizon | Will this problem still matter in 5 years? |
| **A**symmetry | Do you have a unique angle others lack? |
| **R**esistance | Can the toughest reviewer break your argument? |
| **P**arsimony | Is the method elegantly simple? |

**Score tiers:** 🏆 Exquisite (23-25) · 🟢 Refined (18-22) · 🟡 Raw (13-17) · 🔴 Bland (≤12)

Ideas must score ≥18 to proceed past the idea phase.

---

## Advanced Configuration

### Per-Agent Models

```bash
./scripts/setup.sh --mode local \
  --model anthropic/claude-sonnet-4-5 \
  --model-map 'critic=anthropic/claude-sonnet-4-5,writer=anthropic/claude-sonnet-4-5'
```

### Per-Agent Groups

```bash
./scripts/setup.sh --mode channel --channel telegram \
  --group-map 'planner=-100111,coder=-100222,scout=-100333'
```

### Dry Run

```bash
./scripts/setup.sh --mode local --dry-run
```

---

## Project Structure

```
openclaw-wolfpack/
├── SKILL.md                         # AgentSkill manifest
├── scripts/
│   └── setup.sh                     # One-command deployment
├── references/
│   ├── workflows.md                 # Workflow details
│   └── sharp-framework.md           # SHARP scoring guide
└── assets/
    ├── agents.yaml                  # Agent registry
    ├── agent-souls/                 # Per-agent identity files
    │   ├── planner/  (soul.md, agent.md, user.md)
    │   ├── ideator/
    │   ├── critic/
    │   ├── surveyor/
    │   ├── coder/
    │   ├── writer/
    │   ├── reviewer/
    │   └── scout/
    └── workflows/                   # Workflow templates
        ├── paper-pipeline.md
        ├── brainstorm.md
        ├── rebuttal.md
        └── daily-digest.md
```

---

## License

MIT

---

<p align="center">
  <a href="https://myclaw.ai"><strong>Powered by MyClaw.ai</strong></a> — Your 24/7 Personal Agent
</p>
