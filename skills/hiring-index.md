# Hiring Skills

채용 프로세스 시뮬레이션과 채용 준비를 지원하는 스킬 모음.

## 시뮬레이션 (hiring-sim-*)

채용 프로세스를 면접관/채용담당자 관점에서 시뮬레이션합니다.

| 스킬 | 호출 | 설명 |
|------|------|------|
| [이력서 리뷰](hiring-sim-resume-review/SKILL.md) | `$hiring-sim-resume-review` | ATS 시뮬레이션 + 리크루터 스크리닝 |
| [이력서 레드팀](hiring-sim-resume-redteam/SKILL.md) | `$hiring-sim-resume-redteam` | 면접관 관점 감점 적발 (수치 현실성 규모 추정 + GitHub 코드·블로그 직접 대조, Cartesian doubt) |
| [포트폴리오 리뷰](hiring-sim-portfolio-review/SKILL.md) | `$hiring-sim-portfolio-review` | 프로젝트 품질과 의사결정 평가 |
| [포트폴리오 레드팀](hiring-sim-portfolio-redteam/SKILL.md) | `$hiring-sim-portfolio-redteam` | 면접관 관점 비판적 감점 적발 (수치 정합성·모순, Cartesian doubt) |
| [코딩 테스트](hiring-sim-coding-test/SKILL.md) | `$hiring-sim-coding-test` | 회사 맞춤 문제 출제 + 제출 코드 채점(정확성·복잡도·코드품질·견고성) |
| [면접](hiring-sim-interview/SKILL.md) | `$hiring-sim-interview` | 기술/인성/회사가치 면접 시뮬레이션 |
| [통합 파이프라인](hiring-sim-pipeline/SKILL.md) | `$hiring-sim-pipeline` | 회사별 맞춤 전체 프로세스 (REJECT 시 중단) |

## 준비 도구 (hiring-prep-*)

채용 준비를 지원자 관점에서 도와줍니다.

| 스킬 | 호출 | 설명 |
|------|------|------|
| [서류 피드백](hiring-prep-doc-feedback/SKILL.md) | `$hiring-prep-doc-feedback` | 이력서/자소서/포트폴리오 리서치 기반 피드백 |
| [자기소개서 작성](writing-prep-cover-letter/SKILL.md) | `$writing-prep-cover-letter` | 공고+이력서 기반 자소서 작성 (전략 진단, 키워드 매칭, STAR+KKK) |
| [면접 준비 문서](hiring-prep-interview/SKILL.md) | `$hiring-prep-interview` | 공고 분석 + 병렬 리서치 기반 맞춤형 예상 질문 생성 |
| [포트폴리오 제작](portfolio-build/SKILL.md) | `$portfolio-build` | 디자인 레퍼런스 선택(직접/자동) + 기존 자료 기반 슬라이드 포트폴리오 자동 제작 |
| [코딩테스트 준비](hiring-prep-coding-test/SKILL.md) | `$hiring-prep-coding-test` | 회사별 코테 리서치(플랫폼·라이브 여부·난이도·빈출 유형) → 유형별 문제 링크·학습 플랜 준비 문서 |

## 공통 모듈

| 모듈 | 설명 |
|------|------|
| [평가 프레임워크](hiring-common/evaluation-framework.md) | ATS, FAANG 루브릭, STAR 등 실전 평가 기준 |
| [입력 파싱 가이드](hiring-common/input-parser.md) | 이력서/포트폴리오/공고 입력 처리 |
| [Known Company DB](hiring-common/company-profiles.md) | 한국/글로벌 빅테크 채용 프로세스 DB |
| [면접·코테 후기 리서치](hiring-common/interview-research.md) | 회사별 면접/코딩테스트 후기 리서치 + 라이브 코드리뷰 포착 + graceful degradation |
