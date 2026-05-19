#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export SKILL_ARCHIVE_TARGET_NAME="Claude Code"
export SKILL_ARCHIVE_TARGET_DIR="$HOME/.claude/skills"
export SKILL_ARCHIVE_HOOK_DIR="$HOME/.claude/hooks"
export SKILL_ARCHIVE_HOOK_TARGET="$HOME/.claude/hooks/skill-injector.mjs"
export SKILL_ARCHIVE_HOOK_COMMAND="node ~/.claude/hooks/skill-injector.mjs"
export SKILL_ARCHIVE_HOOK_INSTRUCTIONS="Claude Code의 ~/.claude/settings.json에 아래 설정을 추가하세요:"

exec "$SCRIPT_DIR/install-common.sh" "$@"
