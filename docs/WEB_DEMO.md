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
