# Career-Skills

[![GitHub stars](https://img.shields.io/github/stars/techeer-sv/Career-Skills?style=flat-square)](https://github.com/techeer-sv/Career-Skills/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

Codex/OMX와 Claude Code에서 함께 쓰는 실전 스킬 아카이브.

*채용 준비, 코드 리뷰, 학습 도구 — 슬래시 커맨드 하나로.*

---

[시작하기](#시작하기) · [스킬 목록](#스킬-목록) · [워크플로우](#워크플로우) · [호출 예시](#호출-예시) · [로드맵](#로드맵)

---

## 시작하기

```bash
# Codex/OMX 전체 설치 (스킬 + hook)
./scripts/install-codex.sh

# Claude Code 전체 설치 (스킬 + hook)
./scripts/install-claude.sh

# 호환용 dispatcher (target 생략 시 codex)
./scripts/install.sh codex --skills-only
./scripts/install.sh claude --hook-only

# 특정 스킬만 설치
./scripts/install-codex.sh hiring-sim-resume-review
```

설치 후 Codex/OMX에서는 `$hiring-sim-resume-review`, Claude Code에서는 `/hiring-sim-resume-review` 형태로 호출할 수 있습니다.

**요구사항**: Codex CLI 또는 Codex App + oh-my-codex(OMX), 또는 Claude Code CLI

### Hook 설정

Codex용 설치 스크립트는 스킬을 `~/.codex/skills/`에 복사합니다. Codex/OMX hook 기반 자동 주입을 쓰는 환경에서는 hook 파일을 `~/.codex/hooks/`에 복사한 뒤 UserPromptSubmit hook에 아래 명령을 연결하세요:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "type": "command",
        "command": "node ~/.codex/hooks/skill-injector.mjs"
      }
    ]
  }
}
```

설정 후 프롬프트에서 트리거 키워드 입력 시 매칭되는 스킬이 자동 주입됩니다.

Claude Code용 설치는 `./scripts/install-claude.sh`를 사용합니다. 이 경우 스킬은 `~/.claude/skills/`, hook은 `~/.claude/hooks/skill-injector.mjs`에 설치됩니다.

---

## What It Does

| 상황 | 스킬이 하는 일 |
|------|--------------|
| "이력서를 넣기 전에 ATS를 통과할지 모르겠다" | ATS 점수 산출 + 리크루터 스크리닝 시뮬레이션 + 수정 제안 |
| "포트폴리오 프로젝트가 평가자 눈에 어떻게 보일지 모른다" | 의사결정 / 문제해결 / 성과 3축 평가 |
| "면접 전 예상 질문을 체계적으로 정리하고 싶다" | 공고 + 회사 리서치 기반 맞춤형 질문 문서 자동 생성 |
| "합격 가능성을 통합적으로 검증하고 싶다" | 회사별 프로세스 자동 감지 → REJECT 시 즉시 중단 + 피드백 |

---

## 스킬 목록

### 🎯 Hiring — 채용 준비

#### 시뮬레이션 (hiring-sim-*)

채용 프로세스를 면접관 / 채용담당자 관점에서 시뮬레이션.

| 스킬 | 명령어 | 설명 | 상태 |
|------|--------|------|------|
| 이력서 리뷰 | `$hiring-sim-resume-review` | ATS 시뮬레이션 + 리크루터 스크리닝 | ✅ |
| 포트폴리오 리뷰 | `$hiring-sim-portfolio-review` | 포트폴리오 프로젝트 품질 평가 | ✅ |
| 코딩 테스트 | `$hiring-sim-coding-test` | FAANG 스타일 코딩 테스트 시뮬레이션 | 🚧 |
| 면접 | `$hiring-sim-interview` | 기술 / 인성 / 컬처핏 면접 시뮬레이션 | 🚧 |
| 통합 파이프라인 | `$hiring-sim-pipeline` | 회사별 맞춤 전체 프로세스 (REJECT 시 중단) | ✅ |

> 🚧 미완성 — 기본 기능은 동작하나 고도화 진행 중.

#### 준비 도구 (hiring-prep-*)

채용 준비를 지원자 관점에서 도움.

| 스킬 | 명령어 | 설명 | 상태 |
|------|--------|------|------|
| 서류 피드백 | `$hiring-prep-doc-feedback` | 이력서 / 자소서 / 포트폴리오 리서치 기반 피드백 | ✅ |
| 면접 준비 | `$hiring-prep-interview` | 병렬 리서치 기반 맞춤형 면접 예상 질문 문서 생성 | ✅ |

#### 기타

| 스킬 | 명령어 | 설명 | 상태 |
|------|--------|------|------|
| Kevin 피드백 | `$kevin-feedback` | Kevin 페르소나 스타일 이력서 피드백 | ✅ |

---

## 워크플로우

### 채용 준비 워크플로우

```
채용 준비 전체 흐름
────────────────────────────────────────────────────────

  [서류 준비]
  이력서 / 자소서 / 포트폴리오 작성
       │
       ▼
  $hiring-prep-doc-feedback      ← 리서치 기반 피드백
       │
       ▼
  $hiring-sim-resume-review      ← ATS + 리크루터 스크리닝
  $hiring-sim-portfolio-review   ← 포트폴리오 심사

  [면접 준비]
  공고 + 회사 정보
       │
       ▼
  $hiring-prep-interview         ← 맞춤형 예상 질문 문서 생성
       │
       ▼
  $hiring-sim-interview          ← 기술 / 인성 / 컬처핏 면접 모의

  [통합 검증]
       │
       ▼
  $hiring-sim-pipeline
       │
       ├─ 서류 PASS ──▶ 코딩 테스트 PASS ──▶ 면접 PASS ──▶ 최종 합격
       │
       └─ 어느 단계든 REJECT ──▶ 즉시 중단 + 개선 피드백

────────────────────────────────────────────────────────
```

---

## 호출 예시

**이력서 리뷰**
```
$hiring-sim-resume-review
```
이력서 경로 제공 → 공고 붙여넣기 → ATS 점수 + 리크루터 스크리닝 + 수정 제안

**면접 예상 질문 생성**
```
$hiring-prep-interview
```
공고 URL 또는 텍스트 제공 → 회사 리서치 병렬 수행 → 기술 / 인성 / 컬처핏 예상 질문 문서 생성

**통합 파이프라인**
```
$hiring-sim-pipeline
```
이력서 + 공고 → 회사 자동 감지 → 맞춤 프로세스 구성 → 단계별 실행 → REJECT 시 즉시 중단

---

## 로드맵

- [ ] 코딩 테스트 시뮬레이션 고도화 (실시간 피드백, 복잡도 분석)
- [ ] 면접 시뮬레이션 고도화 (음성 모드, 후속 질문 심화)
- [ ] Codex hook 자동 주입 설정 예시 보강
- [ ] Cursor 지원
- [ ] 더 많은 카테고리 추가 (코드 리뷰, 학습 도구 등)

---

## License

MIT — see [LICENSE](LICENSE)
