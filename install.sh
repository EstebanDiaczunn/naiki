#!/bin/bash
# install.sh — Instala NAIKI en el proyecto actual
# Uso desde repo clonado: bash install.sh
# Uso remoto: bash <(curl -s https://raw.githubusercontent.com/EstebanDiaczunn/naiki/main/install.sh)

set -e

# ⚠️ Cambiá esto por tu usuario/org de GitHub
GITHUB_REPO="EstebanDiaczunn/naiki"

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}👁️ Instalando NAIKI...${NC}"
echo ""

# Detectar si estamos corriendo desde el repo o desde curl
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" 2>/dev/null)" && pwd 2>/dev/null || echo "")"
REPO_DIR=""

if [ -f "$SCRIPT_DIR/NAIKI.md" ]; then
    REPO_DIR="$SCRIPT_DIR"
elif [ -f "./NAIKI.md" ] && [ -f "./.claude-plugin/marketplace.json" ]; then
    REPO_DIR="."
else
    # Descargamos a un temp
    REPO_DIR=$(mktemp -d)
    echo "Descargando NAIKI..."
    git clone --depth 1 "https://github.com/${GITHUB_REPO}.git" "$REPO_DIR" 2>/dev/null || {
        echo -e "${YELLOW}No se pudo clonar el repo. Instalación manual necesaria.${NC}"
        echo "Visitá: https://github.com/${GITHUB_REPO}"
        exit 1
    }
    CLEANUP_TEMP=true
fi

# ── NAIKI.md ────────────────────────────────────────────────────────
if [ ! -f "NAIKI.md" ]; then
    cp "$REPO_DIR/NAIKI.md" ./NAIKI.md
    echo -e "${GREEN}✅ NAIKI.md → raíz del proyecto${NC}"
else
    echo -e "${YELLOW}⚠️  NAIKI.md ya existe, no se toca${NC}"
fi

# ── Claude Code (plugin) ────────────────────────────────────────────
if [ -f "CLAUDE.md" ] || [ -d ".claude" ] || command -v claude &>/dev/null; then
    echo ""
    echo -e "${CYAN}Claude Code detectado${NC}"
    echo -e "  Instalá el plugin desde Claude Code:"
    echo ""
    echo -e "  ${GREEN}/plugin marketplace add ${GITHUB_REPO}${NC}"
    echo -e "  ${GREEN}/plugin install naiki-review@naiki${NC}"
    echo ""
    echo -e "  Después usá: ${GREEN}/naiki${NC} o ${GREEN}/naiki focus on error handling${NC}"

    # Inyectar referencia en CLAUDE.md si existe
    if [ -f "CLAUDE.md" ] && ! grep -qi "naiki" CLAUDE.md 2>/dev/null; then
        echo "" >> CLAUDE.md
        echo "## Review" >> CLAUDE.md
        echo "Post-implementación: /simplify (mecánico) → /naiki (criterio)." >> CLAUDE.md
        echo -e "${GREEN}✅ CLAUDE.md actualizado${NC}"
    fi
fi

# ── OpenCode ────────────────────────────────────────────────────────
if [ -f "opencode.json" ] || [ -d ".opencode" ] || [ -f "AGENTS.md" ] || command -v opencode &>/dev/null; then
    echo ""
    echo -e "${CYAN}OpenCode detectado${NC}"
    mkdir -p .opencode/commands
    cp "$REPO_DIR/opencode/commands/naiki.md" .opencode/commands/naiki.md
    echo -e "${GREEN}✅ /naiki comando instalado en .opencode/commands/${NC}"

    if [ -f "AGENTS.md" ] && ! grep -qi "naiki" AGENTS.md 2>/dev/null; then
        echo "" >> AGENTS.md
        echo "## Review" >> AGENTS.md
        echo "Post-implementación: corré /naiki para review de criterio." >> AGENTS.md
        echo -e "${GREEN}✅ AGENTS.md actualizado${NC}"
    fi
fi

# ── Codex ───────────────────────────────────────────────────────────
if [ -d ".codex" ] || [ -d ".agents" ] || command -v codex &>/dev/null; then
    echo ""
    echo -e "${CYAN}Codex detectado${NC}"
    mkdir -p .agents/skills/naiki
    cp "$REPO_DIR/codex/skills/naiki/SKILL.md" .agents/skills/naiki/SKILL.md
    echo -e "${GREEN}✅ \$naiki skill instalado en .agents/skills/naiki/${NC}"

    if [ -f "AGENTS.md" ] && ! grep -qi "naiki" AGENTS.md 2>/dev/null; then
        echo "" >> AGENTS.md
        echo "## Review" >> AGENTS.md
        echo "Post-implementación: usá \$naiki para review de criterio." >> AGENTS.md
        echo -e "${GREEN}✅ AGENTS.md actualizado${NC}"
    fi
fi

# ── Nada detectado ──────────────────────────────────────────────────
if [ ! -f "CLAUDE.md" ] && [ ! -d ".claude" ] && [ ! -f "opencode.json" ] && [ ! -d ".opencode" ] && [ ! -d ".codex" ] && [ ! -d ".agents" ] && [ ! -f "AGENTS.md" ]; then
    echo ""
    echo -e "${YELLOW}No se detectó herramienta específica.${NC}"
    echo "Instalando para todas..."

    mkdir -p .claude/skills/naiki .claude/commands .opencode/commands .agents/skills/naiki
    cp "$REPO_DIR/marketplace/naiki-review/skills/naiki/SKILL.md" .claude/skills/naiki/SKILL.md
    cp "$REPO_DIR/marketplace/naiki-review/commands/naiki.md" .claude/commands/naiki.md
    cp "$REPO_DIR/opencode/commands/naiki.md" .opencode/commands/naiki.md
    cp "$REPO_DIR/codex/skills/naiki/SKILL.md" .agents/skills/naiki/SKILL.md

    echo -e "${GREEN}✅ Instalado para Claude Code, OpenCode y Codex${NC}"
fi

# ── Cleanup ─────────────────────────────────────────────────────────
if [ "${CLEANUP_TEMP:-false}" = true ]; then
    rm -rf "$REPO_DIR"
fi

echo ""
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${CYAN}👁️ NAIKI listo.${NC}"
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo ""
echo "Flujo: implementar → /simplify → /naiki → fix → commit"
echo ""
