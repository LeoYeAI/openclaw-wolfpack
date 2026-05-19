<p align="center">
  <img src="https://img.shields.io/badge/OpenClaw-Wolfpack-blue?style=for-the-badge" alt="OpenClaw Wolfpack">
  <a href="https://myclaw.ai"><img src="https://img.shields.io/badge/Powered%20by-MyClaw.ai-ff6b35?style=flat-square" alt="Powered by MyClaw.ai"></a>
</p>

<h1 align="center">🐺 OpenClaw Wolfpack</h1>

<p align="center"><strong>60秒で<a href="https://docs.openclaw.ai">OpenClaw</a>にAIエージェントチームをデプロイ</strong></p>

<p align="center">
  <a href="README.md">English</a> • <a href="README.zh-CN.md">中文</a> • <a href="README.ja.md">日本語</a> • <a href="README.fr.md">Français</a> • <a href="README.de.md">Deutsch</a> • <a href="README.es.md">Español</a> • <a href="README.ru.md">Русский</a> • <a href="README.it.md">Italiano</a>
</p>

---

**Wolfpack**は[OpenClaw](https://docs.openclaw.ai)用のワンコマンド・マルチエージェントSkillです。**8つの専門AIエージェント**を協調チームとしてデプロイします。

### 🐺 パックメンバー

| エージェント | 役割 | 担当 |
|-------------|------|------|
| 🧠 Planner | 統括者 | タスク分解、進捗管理、エージェント間調整 |
| 💡 Ideator | 発想エンジン | アイデア生成、新規性評価 |
| 🎯 Critic | 品質ゲート | SHARP評価（18点以上で通過） |
| 📚 Surveyor | 文献専門家 | 文献調査、研究ギャップ特定 |
| 💻 Coder | エンジニア | 実装、実験実行 |
| ✍️ Writer | 執筆者 | 論文執筆、LaTeX整形 |
| 🔍 Reviewer | 査読者 | 内部ピアレビュー |
| 📰 Scout | 情報員 | 日次論文ダイジェスト |

### クイックスタート

```bash
git clone https://github.com/LeoYeAI/openclaw-wolfpack.git
cd openclaw-wolfpack && chmod +x scripts/setup.sh
./scripts/setup.sh --mode local --model anthropic/claude-sonnet-4-5
```

詳細は[英語版README](README.md)を参照してください。

---

<p align="center"><a href="https://myclaw.ai"><strong>Powered by MyClaw.ai</strong></a> — Your 24/7 Personal Agent</p>
