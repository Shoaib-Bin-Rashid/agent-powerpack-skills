#!/usr/bin/env bash
# Agent Powerpack Skills - Universal Installer
# Compatible with: Antigravity CLI, Claude Code, OpenAI Codex, OpenCode, Cursor, and Windsurf

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
HOME_DIR="${HOME:-/Users/$(whoami)}"

echo "=================================================="
echo "    Agent Powerpack Skills - Universal Installer  "
echo "=================================================="

install_antigravity() {
    local target="$HOME_DIR/.gemini/skills"
    echo "[*] Installing to Antigravity CLI: $target"
    mkdir -p "$target"
    cp -R "$SKILLS_DIR/teamform" "$target/"
    cp -R "$SKILLS_DIR/hard-review" "$target/"
    echo "    [✔] Successfully installed teamform and hard-review to Antigravity!"
}

install_claude() {
    local target="$HOME_DIR/.claude/skills"
    echo "[*] Installing to Claude Code: $target"
    mkdir -p "$target"
    cp -R "$SKILLS_DIR/teamform" "$target/"
    cp -R "$SKILLS_DIR/hard-review" "$target/"
    echo "    [✔] Successfully installed teamform and hard-review to Claude Code!"
}

install_opencode() {
    local target="$HOME_DIR/.opencode/skills"
    echo "[*] Installing to OpenCode: $target"
    mkdir -p "$target"
    cp -R "$SKILLS_DIR/teamform" "$target/"
    cp -R "$SKILLS_DIR/hard-review" "$target/"
    echo "    [✔] Successfully installed teamform and hard-review to OpenCode!"
}

install_cursor() {
    local target="./.cursor/rules"
    echo "[*] Installing to Cursor / Windsurf in current workspace: $target"
    mkdir -p "$target"
    cp "$SKILLS_DIR/teamform/SKILL.md" "$target/teamform.md"
    cp "$SKILLS_DIR/hard-review/SKILL.md" "$target/hard-review.md"
    echo "    [✔] Successfully installed teamform and hard-review rules to Cursor!"
}

auto_detect() {
    echo "[*] Auto-detecting installed AI agent environments..."
    local detected=0

    if [ -d "$HOME_DIR/.gemini" ]; then
        install_antigravity
        detected=$((detected + 1))
    fi

    if [ -d "$HOME_DIR/.claude" ]; then
        install_claude
        detected=$((detected + 1))
    fi

    if [ -d "$HOME_DIR/.opencode" ]; then
        install_opencode
        detected=$((detected + 1))
    fi

    if [ -d "./.cursor" ] || [ -f "./.cursorrules" ]; then
        install_cursor
        detected=$((detected + 1))
    fi

    if [ "$detected" -eq 0 ]; then
        echo "[!] No default agent configurations auto-detected. Installing to ~/.gemini/skills and ~/.claude/skills by default..."
        install_antigravity
        install_claude
    fi
}

case "${1:-}" in
    --antigravity)
        install_antigravity
        ;;
    --claude)
        install_claude
        ;;
    --opencode)
        install_opencode
        ;;
    --cursor)
        install_cursor
        ;;
    --all)
        install_antigravity
        install_claude
        install_opencode
        install_cursor
        ;;
    --help|-h)
        echo "Usage: ./install.sh [OPTION]"
        echo "Options:"
        echo "  (none)         Auto-detect environments and install"
        echo "  --all          Install to all supported agent directories"
        echo "  --antigravity  Install to Antigravity CLI (~/.gemini/skills/)"
        echo "  --claude       Install to Claude Code (~/.claude/skills/)"
        echo "  --opencode     Install to OpenCode (~/.opencode/skills/)"
        echo "  --cursor       Install to current repo's .cursor/rules/"
        exit 0
        ;;
    *)
        auto_detect
        ;;
esac

echo ""
echo "=================================================="
echo " [✔] Installation Complete! Power up your agents: "
echo "     /teamform     - Parallel Swarm Orchestration "
echo "     /hard-review  - Deep Adversarial Review      "
echo "=================================================="
