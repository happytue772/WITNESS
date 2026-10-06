# THE FIRST WITNESS - iPhone / TestFlight 배포 가이드

## 현재 상태

Flutter 소스는 Android와 iOS를 함께 지원하도록 구성되어 있습니다.

iOS 쪽에는 다음 항목이 반영되어 있습니다.

- 앱 표시 이름: THE FIRST WITNESS
- iPhone 세로 화면 고정
- QR 카메라 권한 설명
- 사진 보관함 권한 설명
- iOS 15.0 이상 배포 타깃
- mobile_scanner / image_picker / shared_preferences / path_provider / share_plus 사용

## 중요한 차이

Android의 APK처럼 iPhone에 파일 하나를 임의로 보내서 바로 설치할 수는 없습니다.

실제 iPhone 설치용 앱은 Apple 코드 서명이 필요합니다.

친구에게 가장 편하게 배포하려면 TestFlight를 사용합니다.

## TestFlight에 필요한 것

1. macOS + Xcode 환경 또는 서명을 지원하는 macOS CI
2. Apple Developer Program 계정
3. 고유 Bundle Identifier
4. App Store Connect 앱 등록
5. Apple 서명 인증서 / 프로비저닝 설정

## 권장 흐름

```text
GitHub WITNESS
    ↓
Mac / Xcode
    ↓
Bundle Identifier + Signing 설정
    ↓
flutter build ipa
    ↓
App Store Connect 업로드
    ↓
TestFlight
    ↓
친구 이메일 초대
    ↓
친구가 TestFlight 앱에서 설치
```

## Mac에서 기본 빌드 확인

```bash
flutter pub get
flutter analyze
flutter test
flutter build ios --release --no-codesign
```

위 명령은 iOS 코드가 빌드되는지 확인하는 용도이며,
생성된 unsigned 앱은 실제 iPhone에 바로 설치할 수 없습니다.

## 실제 TestFlight 빌드

Apple Developer signing을 Xcode에 연결한 뒤:

```bash
flutter build ipa --release
```

빌드된 IPA는 App Store Connect / Transporter / Xcode Organizer를 통해 업로드합니다.

## GitHub Actions

저장소의 **Actions → iOS Build Check → Run workflow**를 실행하면
GitHub의 macOS runner에서 unsigned iOS 빌드 검증을 할 수 있습니다.

생성되는 `WITNESS-iOS-unsigned.zip`은
'빌드 성공 여부 확인용'이며 iPhone 설치용 파일이 아닙니다.

## 아직 임의로 정하지 않은 값

다음 값은 실제 배포 전에 소유자가 결정해야 합니다.

- Bundle Identifier
- Apple Developer Team
- TestFlight 앱 정보
- 최종 앱 아이콘 / 스플래시
- 실제 운영 QR payload
