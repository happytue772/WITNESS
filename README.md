# THE FIRST WITNESS

Flutter 기반 웰니스 탐색 앱 프로토타입입니다.

## 핵심 사용자 흐름

회복 유형 테스트 → 추천 프로그램 → 프로그램 선택 → 프로그램 상세 → 예약 → 디지털 초대장 → 체크인 → 시크릿 맵 → QR 탐색 → 최종 체험 → 사진/후기 기록 → 방문 카드 공유

## 주요 기능

- 시각 / 촉각 / 후각 기반 회복 유형 테스트
- 3개 웰니스 프로그램 조회 및 자유 선택
- DEMO 예약 및 디지털 초대장
- 체크인 후 순차 QR 탐색
- QR 1 → 2 → 3 순서 검증
- 개발용 갤러리 QR 테스트
- 탐색 진행 상태 저장
- 체험 완료 처리
- 사진 + 한 줄 후기 기록
- 방문 카드 PNG 생성 및 공유
- 예약 개별 삭제 및 연결 데이터 정리
- SharedPreferences 기반 로컬 상태 복원
- 진행 중 화면에서 하단 중앙 홈 이동 + 중단 경고

## 프로그램

| ROOM | 감각 | 프로그램 | 장소 | 소요 | 정원 |
| --- | --- | --- | --- | --- | --- |
| ROOM 01 · SIGHT | 시각 | 안개 다도 | 이끼원 | 50분 | 10명 |
| ROOM 02 · TOUCH | 촉각 | 블라인드 요가 | 만병초원 | 50분 | 10명 |
| ROOM 03 · SCENT | 후각 | 아우프구스 사우나 버스 | 사우나버스 | 40분 | 10명 |

## 이미지 Assets

현재 실제 프로그램/브랜드 이미지는 확정 전이므로 임시 아이콘과 그래디언트로 표시합니다.
아래 파일을 추후 추가하면 기존 UI 구조를 유지한 채 실제 이미지로 교체할 수 있습니다.

```text
assets/images/home/welcome_hero.jpg
assets/images/home/home_hero.jpg

assets/images/programs/mist_tea.jpg
assets/images/programs/blind_yoga.jpg
assets/images/programs/aufguss_sauna_bus.jpg

assets/images/exploration/secret_map.png
```

앱에서는 실제 이미지가 없을 때 `이미지 추후 적용` 표시와 임시 아이콘을 사용합니다.

## 탐색 설계

시크릿 맵은 일반 GPS 내비게이션이 아닙니다.

- 오브제와 단서를 이용해 직접 발견하도록 유도
- 현재 순서에 맞는 QR만 인정
- 이전 단서 발견 후 다음 단서 활성화
- 홈으로 나가도 이미 발견한 단서 상태는 유지
- GPS 실시간 위치 추적을 사용하는 것처럼 표현하지 않음

## 홈 이동 UX

단계가 깊어져도 뒤로가기를 반복하지 않도록 주요 하위 화면 하단 중앙에 `홈으로` 버튼을 제공합니다.

진행 중 데이터가 있는 화면에서는 홈 이동 전에 경고합니다.

- 회복 유형 테스트: 답변 진행 상태 미저장 경고
- 예약 작성: 선택한 인원 등 미확정 정보 경고
- 탐색 / QR: 현재 작업 중단 경고, 기존 발견 단서는 유지
- 체험 완료 전: 체험 미완료 경고
- 후기 작성: 저장하지 않은 후기/사진 변경사항 경고

완료된 결과/상세 화면에서는 별도 경고 없이 홈으로 이동합니다.

## 개발 환경 실행

프로젝트 루트:

```powershell
cd C:\dev\projects\first_witness
flutter pub get
flutter analyze
```

Android Studio의 Device Manager에서 Pixel 8 에뮬레이터를 실행한 뒤 Run 할 수 있습니다.

API 36 에뮬레이터에서 검은 화면 또는 그래픽 문제가 재현될 때 임시로:

```powershell
C:\dev\flutter\bin\flutter.bat run -d emulator-5554 --no-enable-impeller
```

을 사용할 수 있습니다.

`--no-enable-impeller`는 앱 기능 요구사항이 아니라 현재 개발용 에뮬레이터의 그래픽 호환 문제를 피하기 위한 임시 옵션입니다.

## 주요 패키지

- shared_preferences
- image_picker
- path_provider
- share_plus
- mobile_scanner

## 현재 단계

핵심 MVP 기능은 구현되어 있으며, 다음 작업은 실제 이미지 교체, 브랜드 디테일 고도화, 실제 Android 기기 QR 테스트, Release 빌드 및 최종 QA입니다.


## Final QA checklist

### 기능 회귀 테스트

- 시작 화면 → 홈 진입
- 회복 유형 테스트 3문항 → 추천 결과
- 프로그램 목록 → 상세 → 예약
- 예약 생성 후 내 예약에 표시
- 예약 삭제 시 연결된 탐색/후기 데이터 정리
- 디지털 초대장 → 체크인
- QR 1 → 2 → 3 순차 검증
- 탐색 중 홈 이동 후 진행 상태 복원
- 체험 완료 → 사진/한 줄 후기 저장
- 기록 → 방문 카드 → PNG 공유
- 앱 재실행 후 예약/탐색/기록 복원
- 진행 중 화면의 하단 `홈으로` 경고 동작

### 이미지 교체 전 확인

실제 브랜드/프로그램 이미지가 확정되기 전까지 임시 아이콘과
`이미지 추후 적용` 표기를 유지합니다. 실제 파일은 기존에 정의된
assets 경로에 같은 파일명으로 추가하면 됩니다.

### Release 전에 반드시 결정할 항목

아래 값은 프로젝트 자료에 확정 정보가 없으므로 임의로 정하지 않습니다.

- Android applicationId / iOS Bundle Identifier
- Android release signing keystore
- 실제 운영 날짜 및 회차 시간
- 실제 체크인 QR payload
- 실제 시크릿 맵 일러스트
- 최종 앱 아이콘 및 스플래시 이미지

현재 Android release 설정은 개발 편의를 위해 debug signing을 사용하므로
스토어 배포 전에는 별도의 release signing 설정이 필요합니다.

### 권장 검증 명령

```powershell
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

실제 기기에서 카메라 QR까지 검증한 뒤 release 빌드를 진행합니다.
