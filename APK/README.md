# APK Build Output

This directory contains the compiled APK files for Android.

## Current Status: Build Successful ✅

APK compiled and installed on device successfully.

| File | Size | Source |
|------|------|--------|
| `behabior-v1.0.0-debug.apk` | 167 MB | `build/app/outputs/flutter-apk/app-debug.apk` |

## Build Commands

```bash
flutter build apk --debug   # Output: build/app/outputs/flutter-apk/app-debug.apk
flutter build apk --release # Output: build/app/outputs/flutter-apk/app-release.apk (requires signing)
```

## Install

```bash
# Via ADB (USB recommended for large APK)
adb install -r build/app/outputs/flutter-apk/app-debug.apk

# Or push then install (better for WiFi ADB)
adb push build/app/outputs/flutter-apk/app-debug.apk /data/local/tmp/
adb shell pm install -r /data/local/tmp/app-debug.apk
```
