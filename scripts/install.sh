#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
사용법:
  ./scripts/install.sh [codex|claude] [--skills-only|--hook-only|--uninstall|<skill-name>]

호환성:
  target을 생략하면 codex로 설치합니다.

예시:
  ./scripts/install.sh codex --skills-only
  ./scripts/install.sh claude --hook-only
  ./scripts/install.sh hiring-sim-resume-review
EOF
}

target="codex"

if [[ $# -gt 0 ]]; then
  case "$1" in
    codex|claude)
      target="$1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
  esac
fi

case "$target" in
  codex)
    exec "$SCRIPT_DIR/install-codex.sh" "$@"
    ;;
  claude)
    exec "$SCRIPT_DIR/install-claude.sh" "$@"
    ;;
esac
