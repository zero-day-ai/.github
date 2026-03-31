#!/bin/bash
# ==============================================================================
# Create All Component Repositories
# ==============================================================================
#
# Creates private GitHub repositories for all Gibson components.
#
# Usage:
#   ./create-all-repos.sh [--dry-run] [--agents-only] [--tools-only] [--plugins-only]
#
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREATE_SCRIPT="${SCRIPT_DIR}/create-component-repo.sh"

# Parse arguments
DRY_RUN=false
AGENTS_ONLY=false
TOOLS_ONLY=false
PLUGINS_ONLY=false

for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            ;;
        --agents-only)
            AGENTS_ONLY=true
            ;;
        --tools-only)
            TOOLS_ONLY=true
            ;;
        --plugins-only)
            PLUGINS_ONLY=true
            ;;
    esac
done

# Component definitions
# Format: name:type:path

declare -a AGENTS=(
    "breach-checker:agent:enterprise/agents/breach-checker"
    "cloud-enum:agent:enterprise/agents/cloud-enum"
    "dns-recon:agent:enterprise/agents/dns-recon"
    "gibson-opencode:agent:enterprise/agents/gibson-opencode"
    "github-scanner:agent:enterprise/agents/github-scanner"
    "gitlab-scanner:agent:enterprise/agents/gitlab-scanner"
    "service-enum:agent:enterprise/agents/service-enum"
    "web-fingerprint:agent:enterprise/agents/web-fingerprint"
)

declare -a TOOLS=(
    "dnsx:tool:core/tools/discovery/dnsx"
    "httpx:tool:core/tools/discovery/httpx"
    "nmap:tool:core/tools/discovery/nmap"
    "nuclei:tool:core/tools/discovery/nuclei"
    "subfinder:tool:core/tools/discovery/subfinder"
    "wappalyzer:tool:core/tools/discovery/wappalyzer"
)

declare -a PLUGINS=(
    "gitlab:plugin:enterprise/plugins/gitlab"
    "scope-ingestion:plugin:enterprise/plugins/scope-ingestion"
)

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

create_repos() {
    local -n components=$1
    local type_name=$2

    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}Creating ${type_name} repositories${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    for component in "${components[@]}"; do
        IFS=':' read -r name type path <<< "$component"

        if [[ "${DRY_RUN}" == "true" ]]; then
            echo -e "${YELLOW}[DRY-RUN]${NC} Would create: gibson-${type}-${name}"
            echo "  Source: ${path}"
        else
            echo -e "${GREEN}Creating:${NC} gibson-${type}-${name}"
            "${CREATE_SCRIPT}" "${name}" "${type}" "${path}"
            echo ""
        fi
    done
}

# Determine what to create
if [[ "${AGENTS_ONLY}" == "true" ]]; then
    create_repos AGENTS "Agent"
elif [[ "${TOOLS_ONLY}" == "true" ]]; then
    create_repos TOOLS "Tool"
elif [[ "${PLUGINS_ONLY}" == "true" ]]; then
    create_repos PLUGINS "Plugin"
else
    # Create all
    create_repos AGENTS "Agent"
    create_repos TOOLS "Tool"
    create_repos PLUGINS "Plugin"
fi

echo ""
echo -e "${GREEN}All repositories created!${NC}"
echo ""
echo "Summary:"
if [[ "${AGENTS_ONLY}" != "true" && "${TOOLS_ONLY}" != "true" && "${PLUGINS_ONLY}" != "true" ]]; then
    echo "  Agents:  ${#AGENTS[@]}"
    echo "  Tools:   ${#TOOLS[@]}"
    echo "  Plugins: ${#PLUGINS[@]}"
    echo "  Total:   $((${#AGENTS[@]} + ${#TOOLS[@]} + ${#PLUGINS[@]}))"
fi
