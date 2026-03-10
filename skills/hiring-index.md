# Hiring Process Simulation Skills

채용 프로세스 전 과정을 시뮬레이션하는 스킬 모음. 실제 기업 채용 프로세스를 기반으로 설계.

## 스킬 목록

| 스킬 | 호출 | 설명 | 평가 체계 |
|------|------|------|----------|
| [이력서 리뷰](hiring-resume-review/SKILL.md) | `/hiring-resume-review` | ATS 시뮬레이션 + 리크루터 스크리닝 | ATS 점수(0~100) + Red Flag 체크 |
| [포트폴리오 리뷰](hiring-portfolio-review/SKILL.md) | `/hiring-portfolio-review` | 프로젝트 품질과 의사결정 평가 | 3영역 평가 (의사결정/문제해결/성과) |
| [서류 피드백](hiring-doc-feedback/SKILL.md) | `/hiring-doc-feedback` | 이력서/자기소개서/포트폴리오 리서치 기반 피드백 | 구조화된 개선 제안 |
| [코딩 테스트](hiring-coding-test/SKILL.md) | `/hiring-coding-test` | FAANG 스타일 코딩 테스트 + Take-home 과제 | 4차원 루브릭 (1~4점) |
| [면접 시뮬레이션](hiring-interview/SKILL.md) | `/hiring-interview` | 기술/인성/회사가치 면접 | 6단계 Hire 스케일 / STAR 5점 |
| [면접 준비 문서](hiring-interview-prep/SKILL.md) | `/hiring-interview-prep` | 공고 분석 + 리서치 기반 맞춤형 예상 질문 생성 | 문서 산출물 |
| [통합 파이프라인](hiring-full-pipeline/SKILL.md) | `/hiring-full-pipeline` | 회사별 맞춤 프로세스 (REJECT 시 중단) | 단계별 PASS/REJECT |

## 공통 모듈

| 모듈 | 설명 |
|------|------|
| [평가 프레임워크](hiring-common/evaluation-framework.md) | ATS, FAANG 루브릭, Take-home, STAR 등 실전 평가 기준 |
| [입력 파싱 가이드](hiring-common/input-parser.md) | 이력서/포트폴리오/공고 입력 처리 + 회사명 추출 |
| [Known Company DB](hiring-common/company-profiles.md) | 한국/글로벌 빅테크 채용 프로세스 DB + 키워드 시그널 |

## 판정 체계

모든 단계: `PASS` / `REJECT` (이분법)
- REJECT 시 구체적 개선 피드백 필수 제공
- 통합 파이프라인에서 REJECT 발생 시 즉시 중단

## 스킬 용도별 분류

### 서류 준비
- `/hiring-doc-feedback` — 서류 피드백 (이력서, 자기소개서, 포트폴리오)
- `/hiring-resume-review` — 이력서 서류 심사 시뮬레이션 (ATS + 리크루터)
- `/hiring-portfolio-review` — 포트폴리오 심사 시뮬레이션

### 면접 준비
- `/hiring-interview-prep` — 맞춤형 면접 예상 질문 문서 생성
- `/hiring-interview` — 면접 시뮬레이션 (기술/인성/컬처핏)

### 코딩 테스트
- `/hiring-coding-test` — 코딩 테스트 시뮬레이션

### 통합
- `/hiring-full-pipeline` — 전체 채용 프로세스 시뮬레이션
