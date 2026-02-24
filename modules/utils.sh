# Sourced by setup.sh — do not run directly.
# ==============================================================================
# utils.sh — Shared helpers: colors, logging, error handling
# ==============================================================================

# Guard against double-sourcing
[[ -n "${__UTILS_LOADED:-}" ]] && return 0
__UTILS_LOADED=1

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Logging ───────────────────────────────────────────────────────────────────

info()    { printf "${BLUE}ℹ${RESET}  %s\n" "$1"; }
success() { printf "${GREEN}✓${RESET}  %s\n" "$1"; }
warn()    { printf "${YELLOW}⚠${RESET}  %s\n" "$1"; }
fail()    { printf "${RED}✗  %s${RESET}\n" "$1"; }

header() {
    echo ""
    printf "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    printf "${BOLD}  %s${RESET}\n" "$1"
    printf "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"
    echo ""
}

# ── Error handling ────────────────────────────────────────────────────────────

abort() {
    echo ""
    fail "$1"
    echo ""
    fail "Setup did not complete. Please share the error above with your team."
    if [[ -n "${LOG_FILE:-}" && -f "${LOG_FILE:-}" ]]; then
        fail "Also share the log file: ${LOG_FILE}"
    fi
    echo ""
    exit 1
}

# Used by setup.sh summary to display what each step did.
_result_label() {
    case "${1:-}" in
        installed_fresh)   echo "freshly installed" ;;
        already_installed) echo "was already set up" ;;
        upgraded)          echo "upgraded to latest" ;;
        *)                 echo "done" ;;
    esac
}

# ── Prompts ───────────────────────────────────────────────────────────────────

wait_for_user() {
    local message="${1:-Press Enter to continue...}"
    echo ""
    printf "${YELLOW}▸${RESET}  ${BOLD}%s${RESET}" "$message"
    read -r
}

# ── Requirement checks ───────────────────────────────────────────────────────

require_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        abort "This script only works on macOS. You appear to be on $(uname)."
    fi
}

require_macos_version() {
    local version major_version
    version=$(sw_vers -productVersion)
    major_version=$(echo "$version" | cut -d. -f1)

    if [[ "$major_version" -lt 14 ]]; then
        abort "Your macOS version ($version) is not supported.
       Homebrew — which this script depends on — requires macOS Sonoma (14) or later.
       Please update your Mac: System Settings → General → Software Update."
    fi
}

require_internet() {
    if ! curl --silent --head --max-time 5 https://www.apple.com >/dev/null 2>&1; then
        abort "No internet connection detected. Please connect to the internet and try again."
    fi
}
