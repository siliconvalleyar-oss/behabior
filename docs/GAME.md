# Behabior - Pixel Defender

## Game Overview

**Behabior** is a professional 2D top-down pixel defender built with **Flutter** and the **Flame Engine**. Players fight waves of enemies in a dark neon-themed world using virtual joystick controls, Rive-animated sprites, and physics-based combat.

**Repo:** https://github.com/siliconvalleyar-oss/behabior

## Gameplay

- **Wave-based combat** — progressive difficulty across 5 levels
- **Virtual joystick** — 8-directional movement + tap-to-attack
- **Enemy variety** — 6 types (Grunt, Runner, Brute, Sniper, Medic, Bomber)
- **Boss battles** — multi-phase AI with shockwave, spread shot, laser, meteor attacks
- **Skill tree** — 6 skills (passive, active, ultimate) with unlock prerequisites
- **Achievements** — 8 unlockable achievements tracking kills, waves, bosses, and secrets
- **Star rating** — 1-3 stars per level based on remaining HP

## Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | 3.2+ | Cross-platform framework |
| Flame Engine | 1.17+ | Game engine, components, camera |
| Forge2D | 0.17+ | Physics simulation |
| Rive | 0.13+ | Animated 2D sprites (.riv) |
| Provider | 6.x | State management |
| SharedPreferences | 2.x | Save/load persistence |
| fl_chart | - | Wave indicators |

## Visual Effects

- **Particle system** — blood, explosions, glass shards, fountain streams
- **Camera shake** — intensity decay on boss attacks/explosions
- **Damage flash** — red overlay on player hit
- **Screen transitions** — smooth fade in/out between screens
- **Fluid effects** — liquid splash, glass shatter, blob physics
- **Dark theme** — purple/neon aesthetic with glass-morphism UI

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── app.dart                   # Root widget + screen router
├── core/                      # Game engine (Flame)
│   ├── core_game.dart         # Main FlameGame orchestrator
│   ├── engine/                # Physics, collision, spawn
│   ├── entities/              # Player, Enemy, Boss, Projectile
│   ├── components/            # Joystick, particles, HUD elements
│   ├── effects/               # Liquid, glass, fluid squad
│   ├── systems/               # Audio, score, wave, skill, achievement
│   ├── config/                # Game constants
│   └── utils/                 # Math helpers, extensions
├── ui/                        # Flutter widget layer
│   ├── screens/               # Menu, Game, LevelSelect, Settings, Shop
│   ├── widgets/               # HUD, PauseMenu, GameOver, WaveIndicator
│   └── themes/                # AppTheme with dark neon colors
└── data/                      # Data/persistence layer
    ├── models/                # Data classes (Level, Enemy, Skill, Achievement)
    ├── repositories/          # Save, level, achievement storage
    └── providers/             # GameState (ChangeNotifier)
```
