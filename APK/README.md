# APK Build Output

This directory contains the compiled APK files for Android.

## Current Status: Build Failed ❌

The project does not compile due to Flame Engine API incompatibilities between the codebase (written for Flame ~1.17) and the resolved version (Flame 1.37+).

### Fix Required

See [TODO.md](../TODO.md) for the full list of build fixes needed.

Key issues:
- Flame API changes (HasTappables, HasDraggables removed/renamed)
- Vector2 import conflicts (vector_math vs vector_math_64)
- Missing dart:ui/dart:math imports
- GameScreen enum naming conflict
- CameraComponent API changes
- Projectile/EnemyModel interface changes

### Build Commands

```bash
flutter build apk --debug   # Output: build/app/outputs/flutter-apk/app-debug.apk
flutter build apk --release # Output: build/app/outputs/flutter-apk/app-release.apk
```

### Expected Output

Once fixed, APKs will be placed here:

| File | Source |
|------|--------|
| `behabior-v1.0.0-debug.apk` | `build/app/outputs/flutter-apk/app-debug.apk` |
| `behabior-v1.0.0-release.apk` | `build/app/outputs/flutter-apk/app-release.apk` |
