#!/bin/bash
# sync.sh — Mac用: GitHubから最新設定を取得して ~/.claude に反映
# Usage: bash sync.sh [push|pull]
# push: ~/.claude → GitHub
# pull: GitHub → ~/.claude (デフォルト)

set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
MODE="${1:-pull}"
ITEMS=("settings.json" "CLAUDE.md" "commands" "skills" "agents" "helpers")

if [ "$MODE" = "push" ]; then
    echo "📤 Mac → GitHub 同期"
    for item in "${ITEMS[@]}"; do
        src="$CLAUDE_DIR/$item"
        if [ -e "$src" ]; then
            cp -r "$src" "$REPO_DIR/"
            echo "  ✅ $item"
        fi
    done
    cd "$REPO_DIR"
    git add -A
    git commit -m "sync $(date '+%Y-%m-%d %H:%M')" || echo "  (変更なし)"
    git push
    echo "✅ GitHubにpush完了"
else
    echo "📥 GitHub → Mac 同期"
    cd "$REPO_DIR"
    git pull
    echo "  ✅ git pull完了"
    mkdir -p "$CLAUDE_DIR"
    for item in "${ITEMS[@]}"; do
        src="$REPO_DIR/$item"
        if [ -e "$src" ]; then
            cp -r "$src" "$CLAUDE_DIR/"
            echo "  ✅ $item → ~/.claude/"
        fi
    done
    echo "✅ 同期完了！"
fi
