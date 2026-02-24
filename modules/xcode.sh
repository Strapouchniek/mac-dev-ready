# Sourced by setup.sh — do not run directly.
# ==============================================================================
# xcode.sh — Install Xcode Command Line Tools
#
# Why first? Xcode CLT provides the core compiler toolchain (clang, make, etc.)
# that Homebrew and Git both depend on. Without it, nothing else installs.
# ==============================================================================

source "${MODULES_DIR}/utils.sh"

install_xcode_clt() {
    header "Step 1 · Xcode Command Line Tools"

    # ── Already installed? ────────────────────────────────────────────────
    if xcode-select -p &>/dev/null; then
        success "Xcode Command Line Tools are already installed."
        XCODE_RESULT="already_installed"
        return 0
    fi

    # ── Explain what's about to happen ────────────────────────────────────
    info "Xcode Command Line Tools are not installed."
    info "This is an Apple package that provides essential developer tools."
    echo ""
    info "What will happen next:"
    info "  1. A macOS popup window will appear asking you to install."
    info "  2. Click ${BOLD}\"Install\"${RESET} (not \"Get Xcode\")."
    info "  3. Accept the license agreement."
    info "  4. Wait for the download and installation to finish."
    info "     This usually takes ${BOLD}5–20 minutes${RESET} depending on your internet."
    echo ""
    warn "Do NOT close Terminal while the installation is running."
    echo ""

    wait_for_user "Press Enter to open the installer..."

    # ── Trigger the macOS installer GUI ───────────────────────────────────
    if ! xcode-select --install 2>/dev/null; then
        warn "The install command returned an unexpected status."
        warn "A popup may already be open — please check your screen."
    fi

    echo ""
    info "The installer popup should now be visible on your screen."
    info "Complete the installation there, then come back here."
    echo ""

    wait_for_user "Press Enter AFTER the Xcode installation has finished..."

    # ── Verify installation ───────────────────────────────────────────────
    local retries=0
    local max_retries=3

    while [[ $retries -lt $max_retries ]]; do
        if xcode-select -p &>/dev/null; then
            echo ""
            success "Xcode Command Line Tools installed successfully!"
            XCODE_RESULT="installed_fresh"
            return 0
        fi

        retries=$((retries + 1))

        if [[ $retries -lt $max_retries ]]; then
            echo ""
            warn "Installation not detected yet (attempt $retries/$max_retries)."
            info "This can happen if the installer is still finishing up."
            echo ""
            wait_for_user "Press Enter to check again..."
        fi
    done

    # ── All retries exhausted ─────────────────────────────────────────────
    echo ""
    fail "Xcode Command Line Tools could not be verified after $max_retries attempts."
    echo ""
    info "Troubleshooting tips:"
    info "  • Make sure the popup installer completed without errors."
    info "  • Try running this in Terminal manually:"
    info "      ${BOLD}xcode-select --install${RESET}"
    info "  • If it says \"already installed\", try restarting Terminal"
    info "    and running this setup script again."
    echo ""
    abort "Xcode Command Line Tools installation could not be verified."
}
