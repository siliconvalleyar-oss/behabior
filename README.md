# Dino Run

Chrome Dino-style endless runner built with **Flutter** & **Flame Engine** for Android.

**Repo:** https://github.com/siliconvalleyar-oss/behabior

## Gameplay

- Tap to jump, hold for higher jump
- Avoid cacti and pterodactyls
- Progressive speed as score increases
- Game over on collision, tap to restart
- High score tracked via ScoreSystem

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter 3.2+ | Cross-platform UI |
| Flame 1.37 | Game engine, components, game loop |

## Quick Start

```bash
git clone https://github.com/siliconvalleyar-oss/behabior.git
cd behabior
flutter pub get
flutter run
```

## Build APK

```bash
flutter build apk --release
```

## Documentation

- [GAME.md](docs/GAME.md) — Game description
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) — Architecture
- [GAME_DESIGN.md](docs/GAME_DESIGN.md) — Game design
- [COMPONENTS.md](docs/COMPONENTS.md) — Components
- [ASSETS.md](docs/ASSETS.md) — Assets
- [TODO.md](TODO.md) — Tasks
