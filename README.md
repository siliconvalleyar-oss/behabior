# ⚔️ Behabior - Pixel Defender

Professional 2D top-down pixel defender built with **Flutter** & **Flame Engine** for Android.

## Features

- **Top-down pixel action** with virtual joystick controls
- **Rive animated sprites** (`.riv` files) for all characters
- **Wave-based combat** with progressive difficulty
- **Boss battles** with multi-phase AI
- **Physics & collision** system
- **Fluid/Liquid/Glass** visual effects
- **Achievement system** with 8+ unlockable achievements
- **Skill tree** with passive, active & ultimate abilities
- **Particle effects**, camera shake, damage flash, screen transitions
- **Audio system** with music, SFX & volume controls
- **5 levels** with increasing difficulty
- **Modular architecture** - clean separation of concerns

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter 3.2+ | Cross-platform UI |
| Flame 1.17 | Game engine |
| Forge2D | Physics (top-down simplified) |
| Rive/Flare | Animated sprites |
| Provider | State management |
| SharedPreferences | Save/Load progress |

## Project Structure

```
lib/
├── main.dart                      # Entry point
├── app.dart                       # App root + router
├── core/                          # Game engine
│   ├── config/game_config.dart    # Constants
│   ├── core_game.dart             # Main FlameGame
│   ├── engine/                    # Physics, collision, spawn
│   ├── entities/                  # Player, enemy, boss, projectile
│   ├── components/                # Joystick, particles, transitions
│   ├── effects/                   # Fluid, glass, liquid
│   ├── systems/                   # Audio, score, wave, skill, achievement
│   └── utils/                     # Math, extensions
├── ui/                            # Flutter UI
│   ├── screens/                   # Menu, game, level select, settings
│   ├── widgets/                   # HUD, pause, game over, indicators
│   └── themes/app_theme.dart      # Theme & colors
└── data/                          # Data layer
    ├── models/                    # Level, enemy, skill, achievement
    ├── repositories/              # Save, level, achievement repos
    └── providers/game_state.dart  # Global state
```

## Getting Started

```bash
# Clone
git clone https://github.com/your-username/behabior.git
cd behabior

# Get dependencies
flutter pub get

# Run
flutter run
```

## Asset Setup

1. Download `.riv` animations from [Rive Community](https://rive.app/community/)
2. Place in `assets/animations/`
3. Add audio files in `assets/audio/`
4. Run `flutter pub get` to update asset manifest

## Documentation

- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - System architecture
- [GAME_DESIGN.md](docs/GAME_DESIGN.md) - Game design document
- [COMPONENTS.md](docs/COMPONENTS.md) - Component reference
- [SYSTEMS.md](docs/SYSTEMS.md) - System documentation
- [ASSETS.md](docs/ASSETS.md) - Asset pipeline
- [API.md](docs/API.md) - Public API reference
