#!/usr/bin/env bash
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

# ─── Required Target Config ───────────────────────────────────────────────────
: "${SKILL_ARCHIVE_TARGET_NAME:?missing SKILL_ARCHIVE_TARGET_NAME}"
: "${SKILL_ARCHIVE_TARGET_DIR:?missing SKILL_ARCHIVE_TARGET_DIR}"
: "${SKILL_ARCHIVE_HOOK_DIR:?missing SKILL_ARCHIVE_HOOK_DIR}"
: "${SKILL_ARCHIVE_HOOK_TARGET:?missing SKILL_ARCHIVE_HOOK_TARGET}"
: "${SKILL_ARCHIVE_HOOK_COMMAND:?missing SKILL_ARCHIVE_HOOK_COMMAND}"
: "${SKILL_ARCHIVE_HOOK_INSTRUCTIONS:?missing SKILL_ARCHIVE_HOOK_INSTRUCTIONS}"

# ─── Paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_ROOT/skills"
TARGET_DIR="$SKILL_ARCHIVE_TARGET_DIR"
HOOK_SOURCE="$REPO_ROOT/hooks/skill-injector.mjs"
HOOK_TARGET="$SKILL_ARCHIVE_HOOK_TARGET"
HOOK_DIR="$SKILL_ARCHIVE_HOOK_DIR"

# ─── Global State ─────────────────────────────────────────────────────────────
SKILL_COUNT=0

# ─── Helpers ──────────────────────────────────────────────────────────────────
print_header() {
  printf "\n🔧 Skill-Archive %s 설치\n" "$SKILL_ARCHIVE_TARGET_NAME"
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
    printf "  ${YELLOW}!${RESET} %s 이미 설치됨. 덮어쓰기? (y/N) " "$skill_name"
    read -r answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      printf "  ${YELLOW}-${RESET} %s 건너뜀\n" "$skill_name"
      return 0
    fi
    rm -rf "$dst"
  fi

  cp -r "$src" "$dst"
  printf "  ${GREEN}✓${RESET} %s\n" "$skill_name"
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
    printf "  ${YELLOW}!${RESET} hook 파일 없음: %s\n" "$HOOK_SOURCE"
    return 0
  fi

  mkdir -p "$HOOK_DIR"
  cp "$HOOK_SOURCE" "$HOOK_TARGET"
  printf "  ${GREEN}✓${RESET} skill-injector.mjs → %s\n" "$HOOK_DIR"

  print_hook_instructions
}

print_hook_instructions() {
  printf "\n%s\n" "$SKILL_ARCHIVE_HOOK_INSTRUCTIONS"
  printf '{\n'
  printf '  "hooks": {\n'
  printf '    "UserPromptSubmit": [\n'
  printf '      {\n'
  printf '        "type": "command",\n'
  printf '        "command": "%s"\n' "$SKILL_ARCHIVE_HOOK_COMMAND"
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

    if [[ "$name" == "hiring-common" ]]; then
      continue
    fi

    if skill_has_files "$dir"; then
      copy_skill "$name"
      (( SKILL_COUNT++ )) || true
    fi
  done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  if [[ -d "$SKILLS_DIR/hiring-common" ]]; then
    install_common
    (( SKILL_COUNT++ )) || true
  fi
}

uninstall_all() {
  printf "제거 중...\n"
  local count=0
  local patterns=("hiring-sim-*" "hiring-prep-*" "hiring-common" "kevin-feedback" "writing-prep-cover-letter")

  for pattern in "${patterns[@]}"; do
    while IFS= read -r -d '' dir; do
      local name
      name="$(basename "$dir")"
      rm -rf "$dir"
      printf "  ${GREEN}✓${RESET} %s 제거됨\n" "$name"
      (( count++ )) || true
    done < <(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type d -name "$pattern" -print0 2>/dev/null || true)
  done

  if [[ -f "$HOOK_TARGET" ]]; then
    rm -f "$HOOK_TARGET"
    printf "  ${GREEN}✓${RESET} skill-injector.mjs 제거됨\n"
  fi

  print_divider
  printf "${GREEN}✅${RESET} 제거 완료: 스킬 %s개\n\n" "$count"
}

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
        printf "${RED}오류:${RESET} 알 수 없는 옵션: %s\n" "$1" >&2
        printf "사용법: %s [--skills-only|--hook-only|--uninstall|<skill-name>]\n" "$0" >&2
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
      printf "${RED}오류:${RESET} 스킬을 찾을 수 없음: %s\n" "$specific_skill" >&2
      exit 1
    fi

    mkdir -p "$TARGET_DIR"
    printf "스킬 설치 중...\n"
    copy_skill "$specific_skill"

    if skill_uses_common "$src"; then
      install_common
    fi

    print_divider
    printf "${GREEN}✅${RESET} 설치 완료: %s\n\n" "$specific_skill"
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
    printf "${GREEN}✅${RESET} 설치 완료: 스킬 %s개, hook 1개\n\n" "$SKILL_COUNT"
  else
    printf "${GREEN}✅${RESET} 설치 완료: 스킬 %s개\n\n" "$SKILL_COUNT"
  fi
}

main "$@"
