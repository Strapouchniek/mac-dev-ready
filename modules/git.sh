# Sourced by setup.sh — do not run directly.
# ==============================================================================
# git.sh — Install and configure Git
#
# Why third? macOS ships a stub git that triggers Xcode CLT installation, and
# CLT itself bundles a (sometimes outdated) copy. We install the latest Git via
# Homebrew so the user always has current features and security patches, then
# set sensible defaults so "git commit" doesn't complain about missing identity.
# Requires Homebrew (installed in Step 2).
# ==============================================================================

source "${MODULES_DIR}/utils.sh"

install_git() {
    header "Step 3 · Git"

    # ── Already installed via Homebrew? ────────────────────────────────────
    if brew list git &>/dev/null 2>&1; then
        local git_version
        git_version="$(git --version)"
        success "Git is already installed via Homebrew ($git_version)."
        GIT_RESULT="already_installed"
        _configure_git
        return 0
    fi

    # ── Fall-back: any git on PATH? ───────────────────────────────────────
    if command -v git &>/dev/null; then
        local git_version
        git_version="$(git --version)"
        info "Found system Git ($git_version)."
        info "Installing the latest version through Homebrew for best compatibility..."
        GIT_RESULT="upgraded"
    else
        GIT_RESULT="installed_fresh"
        info "Git is not installed."
        info "Git is the version-control system that lets you collaborate on code"
        info "and create Pull Requests on GitHub."
    fi

    echo ""
    info "What will happen next:"
    info "  1. Homebrew will download and install the latest Git."
    info "  2. This usually takes about ${BOLD}1–2 minutes${RESET}."
    echo ""

    # ── Install via Homebrew ───────────────────────────────────────────────
    info "Installing Git... (this may take a minute or two)"
    echo ""

    if ! brew install git >> "${LOG_FILE:-/tmp/mac-dev-ready.log}" 2>&1; then
        echo ""
        fail "Homebrew could not install Git."
        echo ""
        info "Troubleshooting tips:"
        info "  • Make sure you have enough disk space."
        info "  • Try running this setup script again."
        echo ""
        abort "Git installation failed."
    fi

    # ── Verify installation ────────────────────────────────────────────────
    [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    hash -r 2>/dev/null || true

    if command -v git &>/dev/null; then
        echo ""
        success "Git installed successfully!"
        success "Version: $(git --version)"
    else
        echo ""
        fail "Git was installed but the 'git' command is not available."
        echo ""
        info "Try closing and reopening Terminal, then run this script again."
        echo ""
        abort "Could not verify Git installation."
    fi

    # ── Basic configuration ────────────────────────────────────────────────
    _configure_git
}

_configure_git() {
    # ── Sensible defaults (always apply, even on re-runs) ─────────────────
    # These are safe to set unconditionally — they don't overwrite user data,
    # just prevent common warnings (e.g. "hint: use --rebase or --no-rebase").
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.autocrlf input

    # ── Identity ──────────────────────────────────────────────────────────
    local current_name current_email
    current_name="$(git config --global user.name 2>/dev/null || true)"
    current_email="$(git config --global user.email 2>/dev/null || true)"

    if [[ -n "$current_name" && -n "$current_email" ]]; then
        success "Git identity already configured: $current_name ($current_email)."
        return 0
    fi

    echo ""
    info "Git needs to know your name and email so your commits are labelled"
    info "correctly. This is stored locally on your Mac, not shared anywhere."
    echo ""

    # ── Name ──────────────────────────────────────────────────────────────
    if [[ -z "$current_name" ]]; then
        printf "${YELLOW}▸${RESET}  ${BOLD}Enter your full name (e.g. Jane Smith):${RESET} "
        read -r git_name || true
        if [[ -z "${git_name:-}" ]]; then
            warn "No name entered — you can set it later by running this script again."
        else
            git config --global user.name "$git_name"
            success "Name set to: $git_name"
        fi
    fi

    # ── Email ─────────────────────────────────────────────────────────────
    if [[ -z "$current_email" ]]; then
        printf "${YELLOW}▸${RESET}  ${BOLD}Enter your email address (the one you use on GitHub):${RESET} "
        read -r git_email || true
        if [[ -z "${git_email:-}" ]]; then
            warn "No email entered — you can set it later by running this script again."
        else
            git config --global user.email "$git_email"
            success "Email set to: $git_email"
        fi
    fi

    echo ""
    success "Git configuration complete."
}
