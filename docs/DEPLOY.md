# Behabior - Deployment Guide

## Prerequisites

- Flutter SDK 3.2+ ([install guide](https://docs.flutter.dev/get-started/install))
- Android SDK 34+ with NDK 25.1+
- Java 17+
- Physical Android device or emulator (API 21+)

## Build for Android

### Debug APK (development)
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (distribution)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

## Build for iOS (macOS only)
```bash
flutter build ios --release
```
Then archive via Xcode.

## Signing Configuration

For release builds, configure `android/app/build.gradle.kts`:

```kotlin
android {
    signingConfigs {
        create("release") {
            storeFile = file("keystore.jks")
            storePassword = System.getenv("STORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `STORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias |
| `KEY_PASSWORD` | Key password |

## CI/CD (Recommended)

### GitHub Actions
```yaml
name: Build
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.22.0'
      - run: flutter pub get
      - run: flutter build apk --release
```

## APK Output

Pre-built APKs are stored in `/APK/` at the project root.

| File | Type | Description |
|------|------|-------------|
| `behabior-v1.0.0-debug.apk` | Debug | Development builds |
| `behabior-v1.0.0-release.apk` | Release | Signed release builds |

## Versioning

Follow semver: `major.minor.patch+build`

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1
```
