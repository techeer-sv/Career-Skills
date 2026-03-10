#!/usr/bin/env bash
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ─── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_ROOT/skills"
TARGET_DIR="$HOME/.claude/skills"
HOOK_SOURCE="$REPO_ROOT/hooks/skill-injector.mjs"
HOOK_TARGET="$HOME/.claude/hooks/skill-injector.mjs"

# ─── Global State ─────────────────────────────────────────────────────────────
SKILL_COUNT=0

# ─── Helpers ──────────────────────────────────────────────────────────────────
print_header() {
  printf "\n🔧 Skill-Archive 설치\n"
  printf "────────────────────────\n\n"
}

print_divider() {
  printf "\n────────────────────────\n"
}

skill_has_files() {
  local dir="$1"
  [[ -f "$dir/SKILL.md" ]] || ls "$dir"/*.md &>/dev/null
}

skill_uses_common() {
  local skill_dir="$1"
  grep -rl "hiring-common" "$skill_dir" &>/dev/null 2>&1
}

copy_skill() {
  local skill_name="$1"
  local src="$SKILLS_DIR/$skill_name"
  local dst="$TARGET_DIR/$skill_name"

  if [[ -d "$dst" ]]; then
    printf "  ${YELLOW}!${RESET} $skill_name 이미 설치됨. 덮어쓰기? (y/N) "
    read -r answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      printf "  ${YELLOW}-${RESET} $skill_name 건너뜀\n"
      return 0
    fi
    rm -rf "$dst"
  fi

  cp -r "$src" "$dst"
  printf "  ${GREEN}✓${RESET} $skill_name\n"
}

install_common() {
  local src="$SKILLS_DIR/hiring-common"
  local dst="$TARGET_DIR/hiring-common"

  if [[ ! -d "$src" ]]; then
    return 0
  fi

  if [[ -d "$dst" ]]; then
    rm -rf "$dst"
  fi

  cp -r "$src" "$dst"
  printf "  ${GREEN}✓${RESET} hiring-common\n"
}

install_hook() {
  printf "Hook 설치 중...\n"

  if [[ ! -f "$HOOK_SOURCE" ]]; then
    printf "  ${YELLOW}!${RESET} hook 파일 없음: $HOOK_SOURCE\n"
    return 0
  fi

  mkdir -p "$HOME/.claude/hooks"
  cp "$HOOK_SOURCE" "$HOOK_TARGET"
  printf "  ${GREEN}✓${RESET} skill-injector.mjs → ~/.claude/hooks/\n"

  print_hook_instructions
}

print_hook_instructions() {
  printf "\nHook을 활성화하려면 ~/.claude/settings.json에 추가하세요:\n"
  printf '{\n'
  printf '  "hooks": {\n'
  printf '    "UserPromptSubmit": [\n'
  printf '      {\n'
  printf '        "type": "command",\n'
  printf '        "command": "node ~/.claude/hooks/skill-injector.mjs"\n'
  printf '      }\n'
  printf '    ]\n'
  printf '  }\n'
  printf '}\n'
}

install_all_skills() {
  printf "스킬 설치 중...\n"
  mkdir -p "$TARGET_DIR"

  while IFS= read -r -d '' dir; do
    local name
    name="$(basename "$dir")"

    # Skip hiring-common (installed separately)
    if [[ "$name" == "hiring-common" ]]; then
      continue
    fi

    if skill_has_files "$dir"; then
      copy_skill "$name"
      (( SKILL_COUNT++ )) || true
    fi
  done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  # Always install hiring-common if present
  if [[ -d "$SKILLS_DIR/hiring-common" ]]; then
    install_common
    (( SKILL_COUNT++ )) || true
  fi
}

uninstall_all() {
  printf "제거 중...\n"
  local count=0

  # NOTE: Uninstall patterns should be updated when new skill categories are added
  local patterns=("hiring-sim-*" "hiring-prep-*" "hiring-common" "kevin-feedback")

  for pattern in "${patterns[@]}"; do
    while IFS= read -r -d '' dir; do
      local name
      name="$(basename "$dir")"
      rm -rf "$dir"
      printf "  ${GREEN}✓${RESET} $name 제거됨\n"
      (( count++ )) || true
    done < <(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type d -name "$pattern" -print0 2>/dev/null || true)
  done

  if [[ -f "$HOOK_TARGET" ]]; then
    rm -f "$HOOK_TARGET"
    printf "  ${GREEN}✓${RESET} skill-injector.mjs 제거됨\n"
  fi

  print_divider
  printf "${GREEN}✅${RESET} 제거 완료: 스킬 ${count}개\n\n"
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  local mode="all"
  local specific_skill=""

  if [[ $# -gt 0 ]]; then
    case "$1" in
      --skills-only)
        mode="skills"
        ;;
      --hook-only)
        mode="hook"
        ;;
      --uninstall)
        mode="uninstall"
        ;;
      --*)
        printf "${RED}오류:${RESET} 알 수 없는 옵션: $1\n" >&2
        printf "사용법: $0 [--skills-only|--hook-only|--uninstall|<skill-name>]\n" >&2
        exit 1
        ;;
      *)
        mode="single"
        specific_skill="$1"
        ;;
    esac
  fi

  if [[ "$mode" == "uninstall" ]]; then
    print_header
    uninstall_all
    return 0
  fi

  print_header

  if [[ "$mode" == "single" ]]; then
    local src="$SKILLS_DIR/$specific_skill"
    if [[ ! -d "$src" ]]; then
      printf "${RED}오류:${RESET} 스킬을 찾을 수 없음: $specific_skill\n" >&2
      exit 1
    fi

    mkdir -p "$TARGET_DIR"
    printf "스킬 설치 중...\n"
    copy_skill "$specific_skill"

    if skill_uses_common "$src"; then
      install_common
    fi

    print_divider
    printf "${GREEN}✅${RESET} 설치 완료: $specific_skill\n\n"
    return 0
  fi

  local hook_installed=0

  if [[ "$mode" == "all" || "$mode" == "skills" ]]; then
    install_all_skills
  fi

  if [[ "$mode" == "all" || "$mode" == "hook" ]]; then
    printf "\n"
    install_hook
    hook_installed=1
  fi

  print_divider
  if [[ $hook_installed -eq 1 ]]; then
    printf "${GREEN}✅${RESET} 설치 완료: 스킬 ${SKILL_COUNT}개, hook 1개\n\n"
  else
    printf "${GREEN}✅${RESET} 설치 완료: 스킬 ${SKILL_COUNT}개\n\n"
  fi
}

main "$@"
