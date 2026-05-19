<p align="center">
  <img src="https://img.shields.io/badge/OpenClaw-Wolfpack-blue?style=for-the-badge" alt="OpenClaw Wolfpack">
  <a href="https://myclaw.ai"><img src="https://img.shields.io/badge/Powered%20by-MyClaw.ai-ff6b35?style=flat-square" alt="Powered by MyClaw.ai"></a>
</p>

<h1 align="center">🐺 OpenClaw Wolfpack</h1>

<p align="center"><strong>Разверните команду ИИ-агентов на <a href="https://docs.openclaw.ai">OpenClaw</a> за 60 секунд</strong></p>

<p align="center">
  <a href="README.md">English</a> • <a href="README.zh-CN.md">中文</a> • <a href="README.ja.md">日本語</a> • <a href="README.fr.md">Français</a> • <a href="README.de.md">Deutsch</a> • <a href="README.es.md">Español</a> • <a href="README.ru.md">Русский</a> • <a href="README.it.md">Italiano</a>
</p>

---

**Wolfpack** — мультиагентный Skill для [OpenClaw](https://docs.openclaw.ai). Разворачивает **8 специализированных ИИ-агентов** как координированную команду с контролем качества SHARP и 4 шаблонами рабочих процессов.

### 🐺 Стая

| Агент | Роль | Ответственность |
|-------|------|-----------------|
| 🧠 Planner | Дирижёр | Декомпозиция задач, координация |
| 💡 Ideator | Креативный движок | Генерация идей, оценка новизны |
| 🎯 Critic | Контроль качества | Оценка SHARP (≥18 для прохождения) |
| 📚 Surveyor | Эксперт по литературе | Обзор литературы |
| 💻 Coder | Инженер | Реализация, эксперименты |
| ✍️ Writer | Автор | Академическое письмо, LaTeX |
| 🔍 Reviewer | Рецензент | Симуляция рецензирования |
| 📰 Scout | Разведчик | Ежедневный дайджест статей |

### Быстрый старт

```bash
git clone https://github.com/LeoYeAI/openclaw-wolfpack.git
cd openclaw-wolfpack && chmod +x scripts/setup.sh
./scripts/setup.sh --mode local --model anthropic/claude-sonnet-4-5
```

Полная документация: [README на английском](README.md).

---

<p align="center"><a href="https://myclaw.ai"><strong>Powered by MyClaw.ai</strong></a> — Your 24/7 Personal Agent</p>
