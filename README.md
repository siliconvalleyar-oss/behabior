# Behabior - Pixel Defender

[![Flutter](https://img.shields.io/badge/Flutter-3.2+-02569B?logo=flutter)](https://flutter.dev)
[![Flame](https://img.shields.io/badge/Flame-1.17+-E6530C?logo=flame)](https://flame-engine.org)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

Professional 2D top-down pixel defender built with **Flutter** & **Flame Engine** for Android.
Wave-based combat, Rive animated sprites, skill tree, achievements, and boss battles.

**Repo:** https://github.com/siliconvalleyar-oss/behabior

## Features

- **Top-down pixel action** with virtual joystick controls
- **Rive animated sprites** (`.riv` files) for all characters
- **Wave-based combat** with progressive difficulty
- **Boss battles** with multi-phase AI (shockwave, spread shot, laser, meteor)
- **Physics & collision** system with layer filtering
- **Fluid/Liquid/Glass** visual effects
- **8 achievements** tracking kills, waves, bosses, and secrets
- **6 skills** (3 passive, 2 active, 1 ultimate) with prerequisites
- **Particle effects**, camera shake, damage flash, screen transitions
- **Audio system** with music, SFX & volume controls
- **5 levels** with 1-3 star rating
- **Modular architecture** with clean separation of concerns

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter 3.2+ | Cross-platform UI |
| Flame 1.17+ | Game engine |
| Forge2D | Physics (top-down simplified) |
| Rive/Flare | Animated sprites |
| Provider | State management |
| SharedPreferences | Save/Load progress |

## Quick Start

```bash
git clone https://github.com/siliconvalleyar-oss/behabior.git
cd behabior
flutter pub get
flutter run
```

## Build APK

```bash
flutter build apk --debug   # Development
flutter build apk --release # Release
```

## Documentation

- [GAME.md](docs/GAME.md) — Full game description
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) — System architecture
- [GAME_DESIGN.md](docs/GAME_DESIGN.md) — Game design document
- [COMPONENTS.md](docs/COMPONENTS.md) — Component reference
- [SYSTEMS.md](docs/SYSTEMS.md) — System documentation
- [SKILLS.md](docs/SKILLS.md) — Skill tree reference
- [ASSETS.md](docs/ASSETS.md) — Asset pipeline
- [API.md](docs/API.md) — Public API reference
- [DEPLOY.md](docs/DEPLOY.md) — Deployment guide
- [TODO.md](TODO.md) — Upcoming tasks and fixes
