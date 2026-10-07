# THE FIRST WITNESS - iPhone Web Demo

이 저장소는 친구의 iPhone에서 Safari로 바로 확인할 수 있도록 Flutter Web 배포를 지원합니다.

## GitHub Pages 최초 1회 설정

GitHub 저장소에서:

1. Settings
2. Pages
3. Build and deployment
4. Source를 **GitHub Actions**로 선택

그 다음 **Actions → Deploy Flutter Web → Run workflow**를 실행하거나 main 브랜치에 push하면 자동 배포됩니다.

정상 배포 후 주소:

```text
https://happytue772.github.io/WITNESS/
```

## 친구 iPhone에서 확인

Safari에서 위 주소를 열면 됩니다.

원하면 Safari 공유 버튼 → **홈 화면에 추가**를 선택해 앱처럼 실행할 수도 있습니다.

## 웹 데모에서 확인하기 좋은 기능

- 시작 화면
- 회복 유형 테스트
- 프로그램 목록 / 상세
- 예약
- 내 예약
- 탐색 진행
- 후기 / 기록
- 사진 선택
- 방문 카드

## 참고

웹 데모는 TestFlight로 설치하는 네이티브 iOS 앱과 동일한 배포 방식은 아닙니다.
Safari 브라우저 권한 정책 때문에 QR 카메라, 공유 등 일부 기능의 동작 방식은 Android APK와 다를 수 있습니다.

예약/진행 상태는 서버 계정이 아니라 브라우저 로컬 저장소를 사용하므로, 각 친구의 iPhone에 서로 독립적으로 저장됩니다.


## 최신 예약/인증 DEMO 흐름

현재 웹 데모는 다음 흐름을 사용합니다.

```text
웰컴
→ 휴대전화 번호 입력
→ DEMO 인증코드 확인
→ 홈
→ 회복 유형 테스트
→ 추천 프로그램 예약
→ 본인 1인 예약 확정
→ 프로그램 준비물 안내
→ 디지털 초대장
```

DEMO 인증번호:

```text
123456
```

실제 SMS 발송은 아직 연결하지 않았습니다.

예약은 본인 1명으로 고정되어 있으며 동반인 수를 선택할 수 없습니다.
동반인은 자신의 기기/브라우저에서 본인 인증 후 각각 예약하는 흐름입니다.

프로그램별 실제 준비물 목록은 현재 제공된 확정 자료에 구체 항목이 없으므로 임의로 만들지 않았습니다.
앱에는 예약 직후 준비물 안내 화면을 두고, 운영 항목 확정 전이라는 안내를 표시합니다.
실제 준비물이 확정되면 Program 데이터의 preparationItems에 연결하면 됩니다.
