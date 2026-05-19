#!/usr/bin/env bash
# ============================================================
#  🐺 OpenClaw Wolfpack — One-Command Multi-Agent Setup
#  Powered by MyClaw.ai
# ============================================================
#  Usage:
#    ./setup.sh                              # Interactive setup
#    ./setup.sh --mode local                 # Local (agentToAgent)
#    ./setup.sh --mode channel --channel telegram --group-id -100xxx
#
#    [Channel Mode]
#    --channel telegram|discord|feishu|whatsapp|slack
#    --group-id ID              Shared group for all agents
#    --group-map 'coder=g1,..'  Per-agent groups
#    --require-mention true     Require @mention (default: true)
#
#    [Universal]
#    --model MODEL              Default model (default: auto-detect)
#    --model-map 'k=v,k=v'     Per-agent model overrides
#    --dry-run                  Preview changes only
# ============================================================

set -euo pipefail

# ── Colors ───────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; MAGENTA='\033[0;35m'; CYAN='\033[0;36m'
BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'

info()    { echo -e "${BLUE}ℹ${NC}  $*"; }
success() { echo -e "${GREEN}✔${NC}  $*"; }
warn()    { echo -e "${YELLOW}⚠${NC}  $*"; }
error()   { echo -e "${RED}✖${NC}  $*" >&2; }
step()    { echo -e "\n${MAGENTA}▸${NC} ${BOLD}$*${NC}"; }

banner() {
  echo ""
  echo -e "${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  ${BOLD}🐺 OpenClaw Wolfpack${NC}  — Multi-Agent Deploy       ${CYAN}║${NC}"
  echo -e "${CYAN}║${NC}  ${DIM}Powered by MyClaw.ai${NC}                              ${CYAN}║${NC}"
  echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
  echo ""
}

# ── Paths ────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
ASSETS_DIR="${SKILL_DIR}/assets"
OPENCLAW_HOME="${HOME}/.openclaw"
OPENCLAW_CONFIG="${OPENCLAW_HOME}/openclaw.json"

# ── Agent Roster ─────────────────────────────────────────────
CORE_AGENTS=(
  "planner|Planner|🧠|Task decomposition and coordination"
  "ideator|Ideator|💡|Idea generation and novelty assessment"
  "critic|Critic|🎯|SHARP taste evaluation and quality gates"
  "surveyor|Surveyor|📚|Literature search and gap identification"
  "coder|Coder|💻|Implementation and experiments"
  "writer|Writer|✍️|Paper writing and LaTeX"
  "reviewer|Reviewer|🔍|Internal peer review"
  "scout|Scout|📰|Daily paper digest and trends"
)

# ── Defaults ─────────────────────────────────────────────────
MODE=""
CHANNEL=""
GROUP_ID=""
GROUP_MAP=""
MODEL=""
MODEL_MAP=""
DRY_RUN=false
REQUIRE_MENTION="true"

# ── Parse Args ───────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    --mode)            MODE="$2";            shift 2 ;;
    --channel)         CHANNEL="$2";         shift 2 ;;
    --group-id)        GROUP_ID="$2";        shift 2 ;;
    --group-map)       GROUP_MAP="$2";       shift 2 ;;
    --model)           MODEL="$2";           shift 2 ;;
    --model-map)       MODEL_MAP="$2";       shift 2 ;;
    --require-mention) REQUIRE_MENTION="$2"; shift 2 ;;
    --dry-run)         DRY_RUN=true;         shift ;;
    -h|--help)
      echo "Usage: ./setup.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --mode MODE         Deployment mode: 'channel' or 'local'"
      echo "  --channel CHANNEL   Channel type (telegram|discord|feishu|whatsapp|slack)"
      echo "  --group-id ID       Default group ID for all agents"
      echo "  --group-map MAP     Per-agent group IDs (coder=g1,scout=g2)"
      echo "  --model MODEL       Default model for all agents"
      echo "  --model-map MAP     Per-agent models (coder=model1,writer=model2)"
      echo "  --require-mention   Require @mention in groups (true|false, default: true)"
      echo "  --dry-run           Preview config without applying"
      echo ""
      exit 0
      ;;
    *) error "Unknown option: $1"; exit 1 ;;
  esac
done

# ── Model Map ────────────────────────────────────────────────
declare -A AGENT_MODELS
if [[ -n "${MODEL_MAP}" ]]; then
  IFS=',' read -ra MAP_ENTRIES <<< "${MODEL_MAP}"
  for entry in "${MAP_ENTRIES[@]}"; do
    AGENT_MODELS["${entry%%=*}"]="${entry#*=}"
  done
fi

# ── Group Map ────────────────────────────────────────────────
declare -A AGENT_GROUPS
if [[ -n "${GROUP_MAP}" ]]; then
  IFS=',' read -ra MAP_ENTRIES <<< "${GROUP_MAP}"
  for entry in "${MAP_ENTRIES[@]}"; do
    AGENT_GROUPS["${entry%%=*}"]="${entry#*=}"
  done
fi

# ── Helpers ──────────────────────────────────────────────────
detect_default_model() {
  # Try to read the current default model from openclaw config (using node, not jq)
  if [[ -f "${OPENCLAW_CONFIG}" ]]; then
    local m
    m=$(node -e "try{const c=JSON.parse(require('fs').readFileSync('${OPENCLAW_CONFIG}','utf8'));const m=c.agents&&c.agents.defaults&&c.agents.defaults.model||c.models&&c.models.default||'';if(m)console.log(m)}catch(e){}" 2>/dev/null || true)
    if [[ -n "$m" ]]; then
      echo "$m"
      return
    fi
  fi
  echo "anthropic/claude-sonnet-4-5"
}

get_model() {
  local agent_id="$1"
  echo "${AGENT_MODELS[${agent_id}]:-${MODEL}}"
}

get_group() {
  local agent_id="$1"
  echo "${AGENT_GROUPS[${agent_id}]:-${GROUP_ID}}"
}

run() {
  if [[ "${DRY_RUN}" == true ]]; then
    echo -e "  ${DIM}[dry-run] \$ $*${NC}"
  else
    eval "$@"
  fi
}

# ── Preflight ────────────────────────────────────────────────
preflight() {
  step "Preflight checks"

  if ! command -v openclaw &>/dev/null; then
    error "openclaw CLI not found. Install: npm install -g openclaw@latest"
    exit 1
  fi
  success "OpenClaw CLI found: $(openclaw --version 2>/dev/null || echo 'unknown')"

  if ! command -v node &>/dev/null; then
    error "node not found. OpenClaw requires Node.js — something is wrong with your installation."
    exit 1
  fi

  if [[ ! -d "${ASSETS_DIR}/agent-souls" ]]; then
    error "Agent soul files not found at ${ASSETS_DIR}/agent-souls"
    exit 1
  fi

  if [[ -f "${OPENCLAW_CONFIG}" ]]; then
    local backup="${OPENCLAW_CONFIG}.wolfpack-backup.$(date +%Y%m%d_%H%M%S)"
    cp "${OPENCLAW_CONFIG}" "${backup}"
    success "Config backed up → ${backup}"
  fi

  # Auto-detect model if not specified
  if [[ -z "${MODEL}" ]]; then
    MODEL="$(detect_default_model)"
    info "Model auto-detected: ${MODEL}"
  fi
}

# ── Interactive Prompts ──────────────────────────────────────
prompt_mode() {
  if [[ -n "${MODE}" ]]; then return; fi

  echo -e "\n${BOLD}Select Deployment Mode:${NC}"
  echo -e "  ${CYAN}1${NC}) Channel Mode — Deploy to Telegram / Discord / Feishu / etc."
  echo -e "  ${CYAN}2${NC}) Local Mode   — CLI only, agents talk via agentToAgent"
  echo -en "\n  Choice [1-2]: "
  read -r m
  case "${m}" in
    2) MODE="local" ;;
    *) MODE="channel" ;;
  esac
}

prompt_channel() {
  if [[ "${MODE}" != "channel" ]]; then return; fi
  if [[ -n "${CHANNEL}" ]]; then return; fi

  echo -e "\n${BOLD}Select channel:${NC}"
  echo -e "  ${CYAN}1${NC}) Telegram"
  echo -e "  ${CYAN}2${NC}) Discord"
  echo -e "  ${CYAN}3${NC}) Feishu (飞书)"
  echo -e "  ${CYAN}4${NC}) WhatsApp"
  echo -e "  ${CYAN}5${NC}) Slack"
  echo -e "  ${CYAN}s${NC}) Skip → switch to Local Mode"
  echo -en "\n  Choice [1-5/s]: "
  read -r choice
  case "${choice}" in
    1) CHANNEL="telegram" ;;
    2) CHANNEL="discord" ;;
    3) CHANNEL="feishu" ;;
    4) CHANNEL="whatsapp" ;;
    5) CHANNEL="slack" ;;
    *) MODE="local"; return ;;
  esac

  if [[ -z "${GROUP_ID}" && -z "${GROUP_MAP}" ]]; then
    echo -e "\n${BOLD}Group assignment:${NC}"
    echo -e "  ${CYAN}1${NC}) All agents in ONE shared group"
    echo -e "  ${CYAN}2${NC}) Individual group per agent"
    echo -en "\n  Choice [1-2]: "
    read -r gc
    if [[ "${gc}" == "2" ]]; then
      for entry in "${CORE_AGENTS[@]}"; do
        IFS='|' read -r id name emoji role <<< "${entry}"
        echo -en "  Group ID for ${BOLD}${emoji} ${name}${NC}: "
        read -r gid
        [[ -n "${gid}" ]] && AGENT_GROUPS["${id}"]="${gid}"
      done
      GROUP_ID="per_agent"
    else
      echo -en "\n  Paste the shared group ID: "
      read -r GROUP_ID
    fi
  fi
}

# ── Create Agents ────────────────────────────────────────────
create_agents() {
  step "Creating ${#CORE_AGENTS[@]} wolfpack agents"

  for entry in "${CORE_AGENTS[@]}"; do
    IFS='|' read -r id name emoji role <<< "${entry}"
    local workspace="${OPENCLAW_HOME}/workspace-${id}"
    local agent_model
    agent_model="$(get_model "${id}")"

    info "${emoji} ${name} → ${agent_model}"
    run "openclaw agents add ${id} --model '${agent_model}' --workspace '${workspace}' 2>/dev/null || true"
    run "openclaw agents set-identity --agent '${id}' --name '${emoji} ${name}' 2>/dev/null || true"
  done
}

# ── Deploy Soul Files ────────────────────────────────────────
deploy_souls() {
  step "Deploying agent identities"

  for entry in "${CORE_AGENTS[@]}"; do
    IFS='|' read -r id name emoji role <<< "${entry}"
    local workspace="${OPENCLAW_HOME}/workspace-${id}"
    local src="${ASSETS_DIR}/agent-souls/${id}"
    local agent_model
    agent_model="$(get_model "${id}")"

    mkdir -p "${workspace}"

    # Deploy source files for self-merge
    [[ -f "${src}/soul.md" ]]  && cp "${src}/soul.md"  "${workspace}/_soul_source.md"
    [[ -f "${src}/user.md" ]]  && cp "${src}/user.md"  "${workspace}/_user_source.md"
    if [[ -f "${src}/agent.md" ]]; then
      sed "s|anthropic/claude-sonnet-4-5|${agent_model}|g" "${src}/agent.md" > "${workspace}/_agent_source.md"
    fi

    # Create BOOTSTRAP.md for first-run self-merge
    cat > "${workspace}/BOOTSTRAP.md" << 'BOOTEOF'
# 🐺 Wolfpack Agent Bootstrap

You are a specialized agent in the OpenClaw Wolfpack multi-agent system.

## First-Run Setup (execute in order):
1. Read `_soul_source.md` → merge into your `SOUL.md`
2. Read `_user_source.md` → merge into your `USER.md`
3. Read `_agent_source.md` → understand your config
4. Check `AGENTS.md` for workflow instructions
5. Delete this file and all `_*_source.md` files
BOOTEOF
  done
}

# ── Append Workflows ────────────────────────────────────────
append_workflows() {
  step "Injecting workflow templates"

  local wf_dir="${ASSETS_DIR}/workflows"

  for entry in "${CORE_AGENTS[@]}"; do
    IFS='|' read -r id name emoji role <<< "${entry}"
    local workspace="${OPENCLAW_HOME}/workspace-${id}"
    local agents_md="${workspace}/AGENTS.md"
    [[ ! -f "${agents_md}" ]] && touch "${agents_md}"

    {
      echo ""; echo "---"
      echo "# 🐺 Wolfpack Workflow Reference for ${emoji} ${name}"
      echo ""

      case "${id}" in
        planner)
          for wf in paper-pipeline brainstorm rebuttal daily-digest; do
            [[ -f "${wf_dir}/${wf}.md" ]] && { echo "---"; cat "${wf_dir}/${wf}.md"; }
          done ;;
        ideator|critic)
          for wf in brainstorm paper-pipeline; do
            [[ -f "${wf_dir}/${wf}.md" ]] && { echo "---"; cat "${wf_dir}/${wf}.md"; }
          done ;;
        surveyor)
          for wf in brainstorm paper-pipeline rebuttal; do
            [[ -f "${wf_dir}/${wf}.md" ]] && { echo "---"; cat "${wf_dir}/${wf}.md"; }
          done ;;
        coder|writer|reviewer)
          for wf in paper-pipeline rebuttal; do
            [[ -f "${wf_dir}/${wf}.md" ]] && { echo "---"; cat "${wf_dir}/${wf}.md"; }
          done ;;
        scout)
          for wf in daily-digest paper-pipeline brainstorm; do
            [[ -f "${wf_dir}/${wf}.md" ]] && { echo "---"; cat "${wf_dir}/${wf}.md"; }
          done ;;
      esac
    } >> "${agents_md}"
  done
}

# ── Configure openclaw.json ─────────────────────────────────
configure_config() {
  step "Configuring openclaw.json (${MODE} mode)"

  # Build new agents data as JSON via node (no jq dependency)
  local agents_data='['
  local first=true
  for entry in "${CORE_AGENTS[@]}"; do
    IFS='|' read -r id name emoji role <<< "${entry}"
    local workspace="${OPENCLAW_HOME}/workspace-${id}"
    local agent_model
    agent_model="$(get_model "${id}")"
    [[ "${first}" == true ]] && first=false || agents_data+=','
    agents_data+="{\"id\":\"${id}\",\"name\":\"${id}\",\"workspace\":\"${workspace}\",\"model\":\"${agent_model}\",\"identity\":{\"name\":\"${emoji} ${name}\"},\"groupChat\":{\"mentionPatterns\":[\"@${id}\",\"${id}\",\"@${name}\"],\"historyLimit\":50}}"
  done
  agents_data+=']'

  # Build channel bindings if needed
  local bindings_data='[]'
  local groups_data='{}'
  if [[ "${MODE}" == "channel" ]]; then
    bindings_data='['
    first=true
    local all_group_ids=()
    for entry in "${CORE_AGENTS[@]}"; do
      IFS='|' read -r id name emoji role <<< "${entry}"
      local agent_group
      agent_group="$(get_group "${id}")"
      [[ "${first}" == true ]] && first=false || bindings_data+=','
      bindings_data+="{\"agentId\":\"${id}\",\"match\":{\"channel\":\"${CHANNEL}\",\"peer\":{\"kind\":\"group\",\"id\":\"${agent_group}\"}}}"
      if [[ ! " ${all_group_ids[*]:-} " =~ " ${agent_group} " ]]; then
        all_group_ids+=("${agent_group}")
      fi
    done
    bindings_data+=']'

    local require_mention_bool=true
    [[ "${REQUIRE_MENTION}" == "false" ]] && require_mention_bool=false
    groups_data='{'
    first=true
    for gid in "${all_group_ids[@]}"; do
      [[ "${first}" == true ]] && first=false || groups_data+=','
      groups_data+="\"${gid}\":{\"requireMention\":${require_mention_bool}}"
    done
    groups_data+='}'
  fi

  local tmp_file
  tmp_file="$(mktemp)"

  node -e "
const fs = require('fs');
const configPath = process.argv[1];
const mode = process.argv[2];
const channel = process.argv[3];
const newAgents = JSON.parse(process.argv[4]);
const newBindings = JSON.parse(process.argv[5]);
const newGroups = JSON.parse(process.argv[6]);
const outPath = process.argv[7];

let config = {};
try { config = JSON.parse(fs.readFileSync(configPath, 'utf8')); } catch(e) {}

// Ensure structure
if (!config.agents) config.agents = {};
if (!Array.isArray(config.agents.list)) config.agents.list = [];

// Remove our agent ids, then append
const ourIds = new Set(newAgents.map(a => a.id));
config.agents.list = config.agents.list.filter(a => !ourIds.has(a.id)).concat(newAgents);

if (mode === 'local') {
  // agentToAgent config
  if (!config.tools) config.tools = {};
  config.tools.agentToAgent = {
    enabled: true,
    allow: ['planner','ideator','critic','surveyor','coder','writer','reviewer','scout']
  };
} else {
  // Channel bindings
  if (!Array.isArray(config.bindings)) config.bindings = [];
  config.bindings = config.bindings.filter(b => !ourIds.has(b.agentId)).concat(newBindings);

  // Channel groups config
  if (!config.channels) config.channels = {};
  if (!config.channels[channel]) config.channels[channel] = {};
  config.channels[channel].groupPolicy = 'open';
  if (!config.channels[channel].groups) config.channels[channel].groups = {};
  Object.assign(config.channels[channel].groups, newGroups);

  // Message history
  if (!config.messages) config.messages = {};
  if (!config.messages.groupChat) config.messages.groupChat = {};
  if (!config.messages.groupChat.historyLimit) config.messages.groupChat.historyLimit = 50;
}

fs.writeFileSync(outPath, JSON.stringify(config, null, 2));
" "${OPENCLAW_CONFIG}" "${MODE}" "${CHANNEL:-none}" "${agents_data}" "${bindings_data}" "${groups_data}" "${tmp_file}"

  if [[ "${DRY_RUN}" == true ]]; then
    info "Dry-run config preview:"
    cat "${tmp_file}"
  else
    cp "${tmp_file}" "${OPENCLAW_CONFIG}"
  fi
  rm -f "${tmp_file}"
  success "openclaw.json updated"
}

# ── Summary ──────────────────────────────────────────────────
summary() {
  echo ""
  echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC}  ${BOLD}🐺 Wolfpack Deployed!${NC}                            ${GREEN}║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${BOLD}Mode:${NC}     $([ "${MODE}" == "local" ] && echo "Local (agentToAgent)" || echo "Channel (${CHANNEL})")"
  echo -e "  ${BOLD}Agents:${NC}   ${#CORE_AGENTS[@]}"
  echo -e "  ${BOLD}Model:${NC}    ${MODEL}"
  echo ""

  if [[ "${MODE}" == "channel" ]]; then
    echo -e "  ${BOLD}Group Bindings:${NC}"
    for entry in "${CORE_AGENTS[@]}"; do
      IFS='|' read -r id name emoji role <<< "${entry}"
      echo -e "    ${emoji} ${id} → $(get_group "${id}")"
    done
    echo ""
  fi

  echo -e "  ${BOLD}Next steps:${NC}"
  if [[ "${MODE}" == "channel" ]]; then
    echo -e "    1. ${CYAN}openclaw gateway restart${NC}"
    echo -e "    2. Message ${CYAN}@planner${NC} in your group"
  else
    echo -e "    1. ${CYAN}openclaw chat planner${NC}"
    echo -e '    2. Say: "Start the paper-pipeline workflow"'
  fi
  echo ""
  echo -e "  ${DIM}Powered by MyClaw.ai — https://myclaw.ai${NC}"
  echo ""
}

# ── Main ─────────────────────────────────────────────────────
main() {
  banner
  preflight
  prompt_mode
  prompt_channel
  create_agents
  deploy_souls
  append_workflows
  configure_config
  if [[ "${DRY_RUN}" != true ]]; then
    openclaw agents list 2>/dev/null || true
  fi
  summary
}

main "$@"
