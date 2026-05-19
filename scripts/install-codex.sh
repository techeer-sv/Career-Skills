#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export SKILL_ARCHIVE_TARGET_NAME="Codex/OMX"
export SKILL_ARCHIVE_TARGET_DIR="$HOME/.codex/skills"
export SKILL_ARCHIVE_HOOK_DIR="$HOME/.codex/hooks"
export SKILL_ARCHIVE_HOOK_TARGET="$HOME/.codex/hooks/skill-injector.mjs"
export SKILL_ARCHIVE_HOOK_COMMAND="node ~/.codex/hooks/skill-injector.mjs"
export SKILL_ARCHIVE_HOOK_INSTRUCTIONS="Codex/OMX의 UserPromptSubmit hook 설정에 아래 명령을 연결하세요:"

exec "$SCRIPT_DIR/install-common.sh" "$@"
