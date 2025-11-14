# License Automator / 라이선스 자동화 툴

<details open>
<summary>🇺🇸 English</summary>
<br>
This tool scans all dependencies in a Flutter project, analyzes each license including <b>SPDX type</b>,  
and generates a <b>single JSON file</b> containing all license information.


## 🚀 Why

The existing `dart_pubspec_licenses` tool is convenient but fails to detect SPDX types  
for some packages like `path_provider`.

This tool combines the **package collection feature** of `dart_pubspec_licenses`  
with the **license analysis engine** of `pana` (used by `pub.dev`)  
to solve this problem accurately and automatically.


## 🛠️ Usage

Add this tool to your **main Flutter app** under `dev_dependencies`.

#### 1. Add to your project

Edit your main app’s `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter

  # ▼ Add this tool ▼
  license_automator: ^1.0.0
```

#### 2.Run
From your project root (where pubspec.yaml is located):
```
flutter pub get
flutter pub run license_automator:generate -o assets/json/licenses.json
```
The generated JSON file will include SPDX identifiers for all dependencies,
including `path_provider`.

``` json
[
  {
    "name": "path_provider",
    "version": "2.1.3",
    "spdxIdentifiers": "BSD-3-Clause",
    "license": "...",
    "repository": "https://github.com/flutter/plugins/tree/main/packages/path_provider",
    "description": "Flutter plugin for finding commonly used locations on the filesystem."
  }
]
```

## 📝 Summary

| Item             | Description                                                        |
| ---------------- | ------------------------------------------------------------------ |
| Install location | `dev_dependencies`                                                 |
| Command          | `flutter pub run license_automator:generate`                       |
| Output           | JSON (configurable via `-o` option)                                |
| Features         | Includes SPDX type / automatic analysis / no manual cleanup needed |



</details>


<details open> <summary>🇰🇷 한국어</summary>
<br>
이 툴은 Flutter 프로젝트의 모든 의존성 라이선스 정보를 <b>SPDX 타입(라이선스 종류)</b>까지 정확하게 분석하여 하나의 JSON 파일로 생성합니다.

## 🚀 왜 만들었는가?

기존의 `dart_pubspec_licenses` 툴은 편리하지만, `path_provider` 같은 일부 패키지의 SPDX(라이선스 타입)를 탐지하지 못하는 치명적인 결함이 있습니다.

이 툴은 `dart_pubspec_licenses`의 '패키지 정보 수집' 기능과 `pub.dev`가 실제로 사용하는 `pana`의 '정확한 라이선스 타입 분석' 엔진을 결합하여 이 문제를 해결했습니다.

(수동 노가다를 막기 위해 만듦)

## 🛠️ 사용법
이 툴은 **메인 Flutter 앱**의 `dev_dependencies`로 추가하여 사용합니다.

### 1. 메인 앱 설정

라이선스 생성이 필요한 메인 Flutter 앱의 `pubspec.yaml` 파일을 엽니다.
`dev_dependencies:` 항목에 이 Git 저장소 주소를 추가합니다.

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # ▼▼▼ 이 툴 추가 ▼▼▼
  license_automator: ^1.0.0

```

### 2. 실행

메인 Flutter 앱 프로젝트의 루트 폴더( pubspec.yaml이 있는 곳)에서 다음 명령어를 실행합니다.

1. 패키지 설치
```
flutter pub get
```

2. 라이선스 JSON 생성
```
flutter pub run license_automator:generate -o assets/json/licenses.json
```

이제 -o 옵션으로 지정한 경로 (assets/json/licenses.json)에 path_provider의 spdxIdentifiers까지 완벽하게 포함된 최종 JSON 파일이 생성됩니다.

``` json
[
  {
    "name": "path_provider",
    "version": "2.1.3",
    "spdxIdentifiers": "BSD-3-Clause",
    "license": "...",
    "repository": "https://github.com/flutter/plugins/tree/main/packages/path_provider",
    "description": "Flutter plugin for finding commonly used locations on the filesystem."
  }
]

```


## 📝 요약

| 항목    | 설명                                           |
| ----- | -------------------------------------------- |
| 설치 위치 | `dev_dependencies`                           |
| 실행 명령 | `flutter pub run license_automator:generate` |
| 출력 파일 | JSON (`-o` 옵션 지정 가능)                         |
| 특징    | SPDX 타입 포함 / 자동 분석 / 수동 정리 불필요               |
</details>
