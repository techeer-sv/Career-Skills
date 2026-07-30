# Backend Engineer — 시장 기대 역량 (엔진 D)

> 사용 규칙·공통 기준은 `../position-competency-map.md` 참조. 여기선 백엔드 직군만.

**핵심 기대 역량**
- **대규모 트래픽·동시성**: 높은 RPS/동시요청 처리, 병목 분석, 커넥션 풀·스레드 모델 이해.
- **성능 테스트 → 개선**: k6/JMeter/Gatling/nGrinder로 부하 걸어 병목을 *측정*하고 개선(결과 수치만 아니라 **측정 과정**).
- **고가용성(HA)·장애 내성**: failover, 다중화, Circuit Breaker·retry·timeout·graceful degradation, 헬스체크.
- **데이터스토어 심화**: DB 인덱스·쿼리 튜닝, 트랜잭션 격리수준, 읽기 복제(read replica)·샤딩·커넥션 풀; **Redis는 단순 캐시를 넘어 HA(Sentinel)·Cluster·영속화·메모리 정책** 이해.
- **MSA·분산 시스템**: 서비스 분리, 이벤트 기반, 분산 트랜잭션(SAGA/Outbox), 멱등성, 서비스 간 통신(gRPC/REST/메시지).
- **컨테이너·오케스트레이션**: Docker, **Kubernetes 배포**(HPA·롤링·리소스 관리), IaC.
- **메시지 큐·스트리밍**: Kafka/RabbitMQ, 캐싱 전략(Cache-Aside/Write-Behind), 백프레셔.
- **관측성·SLO**: 메트릭·트레이싱, 에러 예산, 알림.
- **보안**: 인증/인가(OAuth·JWT), 입력 검증, 시크릿 관리.

**깊이 공백 신호**: "성능 N% 개선"만 있고 부하도구·병목 원인·측정 조건 없음 · "Redis 캐싱"만 있고 HA/무효화 전략 없음 · "MSA" 표방인데 분산 트랜잭션·정합성 고민 없음.

**공백 시 후속질문**: "부하는 무슨 도구로 어디까지 줬고 병목은 뭐였나요?" · "Redis 노드가 죽으면요? Sentinel/Cluster 써봤나요?" · "서비스가 죽었을 때 전파를 어떻게 막나요?" · "K8s로 배포·스케일링해봤나요?"
