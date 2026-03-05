# 👁️ NAIKI

Code review with human judgment for AI-powered development.

NAIKI is not a linter. It evaluates what automated tools can't: **proportionality, domain understanding, and honest self-assessment**. It works alongside `/simplify` (Claude Code) or any mechanical cleanup tool.

## Install

### Claude Code (plugin)

```
/plugin marketplace add EstebanDiaczunn/naiki
/plugin install naiki-review@naiki
```

Done. Use `/naiki` after any task.

### OpenCode / Codex / All tools

```bash
bash <(curl -s https://raw.githubusercontent.com/EstebanDiaczunn/naiki/main/install.sh)
```

Auto-detects your tools and installs the right files.

### Manual

Copy `NAIKI.md` to your project root. Copy the command/skill for your tool:

| Tool | Copy to |
|---|---|
| Claude Code | `.claude/skills/naiki/SKILL.md` |
| OpenCode | `.opencode/commands/naiki.md` |
| Codex | `.agents/skills/naiki/SKILL.md` |

## Usage

```bash
# Claude Code
/naiki                          # Full review
/naiki focus on error handling  # Focused review

# OpenCode
/naiki
/naiki naming

# Codex
$naiki
```

## What it checks

- **Proportionality** — Is the complexity justified? No DDD in a CRUD, no spaghetti in critical systems.
- **Naming** — Descriptive everywhere. `data`, `result`, `temp` = rejected.
- **Separation** — Business logic in the right layer. Not in controllers.
- **Error handling** — Handled with context, not swallowed silently.
- **Domain modeling** — Entities with meaning, not generic arrays.
- **Hardcoding** — Magic strings/numbers parametrized.
- **Data operations** — No N+1, pagination present, transactions where needed.
- **Over-engineering** — No unnecessary abstractions or patterns without justification.

## NAIKI vs /simplify

| | `/simplify` | `/naiki` |
|---|---|---|
| What | Mechanical cleanup | Human judgment |
| Checks | Reuse, efficiency, formatting | Proportionality, understanding, risks |
| Output | Auto-applied fixes | REPORTE A NAIKI with verdict |
| Context cost | On-demand | On-demand (~0 tokens idle) |

**Recommended flow:** Implement → `/simplify` → `/naiki` → fix → commit

## Customize

Edit `NAIKI.md` in your project root to add project-specific standards, domain rules, or adjust the review criteria. The skills/commands reference it automatically.

## Structure

```
naiki/
├── NAIKI.md                                    # The soul — goes in every project root
├── install.sh                                  # Universal installer
├── .claude-plugin/
│   └── marketplace.json                        # Claude Code marketplace manifest
├── marketplace/naiki-review/                   # Claude Code plugin
│   ├── .claude-plugin/plugin.json
│   ├── skills/naiki/SKILL.md
│   └── commands/naiki.md
├── opencode/commands/naiki.md                  # OpenCode command
├── codex/skills/naiki/SKILL.md                 # Codex skill
└── README.md
```

---

> **El mejor código no es el más inteligente. Es el más claro.** — Naiki 👁️
