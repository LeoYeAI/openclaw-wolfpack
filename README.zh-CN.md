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
  <strong>60秒内在 <a href="https://docs.openclaw.ai">OpenClaw</a> 上部署一支协作AI智能体团队</strong>
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

## 这是什么？

**Wolfpack（狼群）** 是 [OpenClaw](https://docs.openclaw.ai) 的一键多智能体部署 Skill。它将 **8个专业化AI Agent** 作为一支协调团队部署——包含身份定义、品质关卡和工作流模板。

相当于一键部署一整个AI科研实验室。

### 🐺 狼群成员

| Agent | 角色 | 职责 |
|-------|------|------|
| 🧠 **Planner** | 统筹规划师 | 任务分解、进度追踪、跨Agent协调 |
| 💡 **Ideator** | 创意研究员 | Idea生成、新颖性评估、ACE评分 |
| 🎯 **Critic** | 品鉴师 | SHARP品味评估（≥18分才能通过） |
| 📚 **Surveyor** | 文献专家 | 文献检索、Research Gap识别 |
| 💻 **Coder** | 代码工程师 | 算法实现、实验执行 |
| ✍️ **Writer** | 论文写手 | 学术写作、LaTeX排版 |
| 🔍 **Reviewer** | 内部审稿人 | 模拟顶会审稿、弱点诊断 |
| 📰 **Scout** | 学术情报员 | 每日论文速递、趋势追踪 |

### 🔥 核心特性

- **一键部署** — 一条命令创建8个Agent
- **SHARP品质关卡** — Critic守门，平庸idea不准通过
- **对抗性协作** — Ideator↔Critic 和 Writer↔Reviewer 互相博弈
- **4个工作流模板** — 论文流水线、头脑风暴、Rebuttal、每日速递
- **双部署模式** — Channel模式（Telegram/Discord/飞书等）或 Local模式（CLI）
- **安全合并** — 追加配置，不覆盖已有Agent

---

## 快速开始

### 安装

```bash
git clone https://github.com/LeoYeAI/openclaw-wolfpack.git
cd openclaw-wolfpack
chmod +x scripts/setup.sh
```

### 部署

```bash
# 交互式
./scripts/setup.sh

# Local模式（无需聊天平台）
./scripts/setup.sh --mode local --model anthropic/claude-sonnet-4-5

# Channel模式（例如Telegram）
./scripts/setup.sh --mode channel --channel telegram --group-id -1001234567890
```

### 使用

```bash
# Local模式
openclaw chat planner
# → "启动paper-pipeline工作流，研究方向：多智能体推理效率"

# Channel模式
openclaw gateway restart
# → 在群组中 @planner
```

---

## SHARP 品鉴框架

Critic的品质关卡评分体系：

| 维度 | 核心问题 |
|------|---------|
| **S**harpness（锐度） | 能否一句话说清为什么work？ |
| **H**orizon（视野） | 这个问题5年后还重要吗？ |
| **A**symmetry（不对称性） | 你有别人没有的独特视角吗？ |
| **R**esistance（抗审稿性） | 最刁钻的审稿人能打穿你吗？ |
| **P**arsimony（简约性） | 方法是否优雅简洁？ |

**评级**：🏆 Exquisite (23-25) · 🟢 Refined (18-22) · 🟡 Raw (13-17) · 🔴 Bland (≤12)

Idea必须达到18分才能进入下一阶段。

---

## 工作流

| 工作流 | 用途 | 流程 |
|--------|------|------|
| 📋 Paper Pipeline | 完整论文产出 | 调研→Idea→品鉴→设计→编码→实验→写作→审稿→提交 |
| 💡 Brainstorm | 快速Idea生成 | 发散→筛选→SHARP过滤→定稿 |
| 🔄 Rebuttal | 审稿意见回复 | 分析→策略→并行执行→撰写→内审→提交 |
| 📰 Daily Digest | 每日学术监控 | 采集→筛选→摘要→预警→分发 |

---

## 致谢

灵感来自 [shenhao-stu/openclaw-agents](https://github.com/shenhao-stu/openclaw-agents)。重新封装为可移植的 OpenClaw Skill，加入 MyClaw 品牌化、改进默认配置和简化部署流程。

## License

MIT

---

<p align="center">
  <a href="https://myclaw.ai"><strong>Powered by MyClaw.ai</strong></a> — Your 24/7 Personal Agent
</p>
