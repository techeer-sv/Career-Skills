# Frontend Engineer — 시장 기대 역량 (엔진 D)

> 사용 규칙·공통 기준은 `../position-competency-map.md` 참조. 여기선 프론트엔드 직군만.

**핵심 기대 역량**
- **렌더링 성능**: Core Web Vitals(LCP/CLS/INP), 번들 사이즈 최적화, code splitting·lazy loading·이미지 최적화·가상 스크롤, 리렌더 최소화(memo/가상화).
- **상태관리 아키텍처**: 클라 상태(Redux/Zustand/Recoil) vs **서버 상태(TanStack Query/SWR)** 분리, 캐시·무효화.
- **프레임워크 심화**: SSR/SSG/ISR(Next.js 등), 하이드레이션, 라우팅, 스트리밍.
- **타입 안정성**: TypeScript strict, 제네릭·유틸 타입.
- **테스트**: 단위(Jest/Vitest+RTL), E2E(Playwright/Cypress), 시각 회귀.
- **컴포넌트 설계·디자인 시스템**: 재사용·합성, 스토리북, 접근성(a11y/WCAG).
- **빌드 툴링**: Vite/Webpack/Turbopack, 모노레포, 트리셰이킹.
- **실시간·통신**: WebSocket/SSE, API 연동(REST/GraphQL), 에러·로딩 UX(Suspense).
- **프론트 관측성**: Sentry/RUM, 성능 예산.

**깊이 공백 신호**: "성능 개선"인데 CWV 지표·측정 도구 없음 · 상태관리 라이브러리만 나열, 서버상태/캐시 전략 없음 · 접근성·테스트 언급 0.

**공백 시 후속질문**: "LCP/INP를 어떻게 측정하고 뭘 바꿨나요?" · "서버 상태와 클라 상태를 어떻게 나눴나요?" · "접근성/테스트는 어떻게 챙겼나요?" · "SSR과 CSR 중 왜 그걸 골랐나요?"
