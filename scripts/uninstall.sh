#!/usr/bin/env bash
# ============================================================
#  🐺 OpenClaw Wolfpack — Uninstall (Clean Removal)
#  Powered by MyClaw.ai
# ============================================================
#  Usage:
#    ./uninstall.sh              # Interactive confirmation
#    ./uninstall.sh --force      # Skip confirmation
#    ./uninstall.sh --dry-run    # Preview only
# ============================================================

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; MAGENTA='\033[0;35m'; CYAN='\033[0;36m'
BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'

info()    { echo -e "${BLUE}ℹ${NC}  $*"; }
success() { echo -e "${GREEN}✔${NC}  $*"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $*"; }
error()   { echo -e "${RED}✖${NC}  $*" >&2; }
step()    { echo -e "\n${MAGENTA}▸${NC} ${BOLD}$*${NC}"; }

OPENCLAW_HOME="${HOME}/.openclaw"
FORCE=false
DRY_RUN=false

WOLFPACK_AGENTS=(planner ideator critic surveyor coder writer reviewer scout)

while [[ $# -gt 0 ]]; do
  case $1 in
    --force)   FORCE=true;   shift ;;
    --dry-run) DRY_RUN=true; shift ;;
    -h|--help)
      echo "Usage: ./uninstall.sh [--force] [--dry-run]"
      exit 0
      ;;
    *) error "Unknown option: $1"; exit 1 ;;
  esac
done

echo ""
echo -e "${RED}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║${NC}  ${BOLD}🐺 OpenClaw Wolfpack — Uninstall${NC}                 ${RED}║${NC}"
echo -e "${RED}╚═══════════════════════════════════════════════════╝${NC}"
echo ""

if [[ "${FORCE}" != true && "${DRY_RUN}" != true ]]; then
  echo -e "This will remove all 8 Wolfpack agents and their workspaces."
  echo -e "Your main agent and other config will ${BOLD}NOT${NC} be affected."
  echo ""
  echo -en "  Continue? [y/N]: "
  read -r confirm
  if [[ "${confirm}" != "y" && "${confirm}" != "Y" ]]; then
    echo "Cancelled."
    exit 0
  fi
fi

# ── Backup config ────────────────────────────────────────────
step "Backing up config"
if [[ -f "${OPENCLAW_HOME}/openclaw.json" ]]; then
  backup="${OPENCLAW_HOME}/openclaw.json.wolfpack-uninstall-backup.$(date +%Y%m%d_%H%M%S)"
  if [[ "${DRY_RUN}" == true ]]; then
    info "[dry-run] Would backup → ${backup}"
  else
    cp "${OPENCLAW_HOME}/openclaw.json" "${backup}"
    success "Backed up → ${backup}"
  fi
fi

# ── Remove agents via CLI ───────────────────────────────────
step "Removing Wolfpack agents"
for agent_id in "${WOLFPACK_AGENTS[@]}"; do
  if [[ "${DRY_RUN}" == true ]]; then
    info "[dry-run] Would remove agent: ${agent_id}"
  else
    if openclaw agents delete "${agent_id}" --force 2>/dev/null; then
      success "Removed: ${agent_id}"
    else
      warn "Agent ${agent_id} not found or already removed"
    fi
  fi
done

# ── Clean agentToAgent config ───────────────────────────────
step "Cleaning agentToAgent config"
if [[ -f "${OPENCLAW_HOME}/openclaw.json" ]]; then
  if [[ "${DRY_RUN}" == true ]]; then
    info "[dry-run] Would remove agentToAgent.allow rules for wolfpack agents"
  else
    node -e "
const fs = require('fs');
const configPath = '${OPENCLAW_HOME}/openclaw.json';
try {
  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  const wolfpackIds = new Set(['planner','ideator','critic','surveyor','coder','writer','reviewer','scout']);
  // Remove agentToAgent allow entries for wolfpack agents
  if (config.tools && config.tools.agentToAgent && Array.isArray(config.tools.agentToAgent.allow)) {
    config.tools.agentToAgent.allow = config.tools.agentToAgent.allow.filter(id => !wolfpackIds.has(id));
    if (config.tools.agentToAgent.allow.length === 0) {
      delete config.tools.agentToAgent;
    }
  }
  // Remove wolfpack bindings
  if (Array.isArray(config.bindings)) {
    config.bindings = config.bindings.filter(b => !wolfpackIds.has(b.agentId));
    if (config.bindings.length === 0) delete config.bindings;
  }
  // Remove wolfpack agents from agents.list
  if (config.agents && Array.isArray(config.agents.list)) {
    config.agents.list = config.agents.list.filter(a => !wolfpackIds.has(a.id));
  }
  fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
  console.log('Config cleaned');
} catch(e) { console.error('Failed to clean config:', e.message); }
" 2>&1
    success "Config cleaned"
  fi
fi

# ── Clean leftover workspace dirs ───────────────────────────
step "Cleaning workspace directories"
for agent_id in "${WOLFPACK_AGENTS[@]}"; do
  local_ws="${OPENCLAW_HOME}/workspace-${agent_id}"
  if [[ -d "${local_ws}" ]]; then
    if [[ "${DRY_RUN}" == true ]]; then
      info "[dry-run] Would remove: ${local_ws}"
    else
      rm -rf "${local_ws}"
      success "Removed: ${local_ws}"
    fi
  fi
done

# ── Summary ──────────────────────────────────────────────────
echo ""
if [[ "${DRY_RUN}" == true ]]; then
  echo -e "${YELLOW}Dry-run complete. No changes made.${NC}"
else
  echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}  ${BOLD}🐺 Wolfpack Uninstalled${NC}                          ${GREEN}║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  Agents removed, config cleaned, workspaces deleted."
  echo -e "  Your main agent is untouched."
  echo ""
  echo -e "  ${BOLD}Next:${NC} ${CYAN}openclaw gateway restart${NC}"
fi
echo ""
