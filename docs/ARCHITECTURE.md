# Behabior Architecture

## Overview

Behabior follows a layered architecture with clear separation between the **game engine** (Flame), **UI layer** (Flutter widgets), and **data layer** (models/repositories/providers).

```
┌─────────────────────────────────────────────┐
│                 UI Layer                     │
│  ┌──────────┐ ┌──────────┐ ┌─────────────┐  │
│  │  Screens │ │  Widgets │ │   Themes    │  │
│  └────┬─────┘ └────┬─────┘ └──────┬──────┘  │
│       │            │              │         │
├───────┴────────────┴──────────────┴─────────┤
│               Game Layer                    │
│  ┌──────────────┐  ┌──────────────────────┐ │
│  │  CoreGame    │  │   Flame Components   │ │
│  │  (FlameGame) │  │   (Entities, FX)     │ │
│  └──────┬───────┘  └──────────┬───────────┘ │
│         │                     │             │
├─────────┴─────────────────────┴─────────────┤
│              Data Layer                      │
│  ┌──────────┐ ┌────────────┐ ┌───────────┐  │
│  │  Models  │ │ Repos      │ │ Providers │  │
│  └──────────┘ └────────────┘ └───────────┘  │
└──────────────────────────────────────────────┘
```

## Layer Details

### 1. Data Layer (`lib/data/`)

- **Models** - Pure data classes with `Equatable`. No logic.
  - `LevelModel`, `EnemyModel`, `SkillModel`, `AchievementModel`, `WaveModel`
- **Repositories** - Handle persistence via `SharedPreferences`
  - `SaveRepository` - Generic key-value storage
  - `LevelRepository` - Level progress & unlock state
  - `AchievementRepository` - Achievement progress & unlock
- **Providers** - `GameState` extends `ChangeNotifier` for global state management via Provider

### 2. Game Layer (`lib/core/`)

- **`CoreGame`** - Main `FlameGame` subclass. Orchestrates all game systems.
- **Engine** (`core/engine/`):
  - `PhysicsEngine` - Spatial queries, raycasts
  - `CollisionSystem` - Circle-based overlap detection with layers
  - `SpawnEngine` - Wave-based enemy/boss spawning
- **Entities** (`core/entities/`):
  - `BaseEntity` - Abstract entity with HP, position, state machine
  - `Player` - Input-driven, skills, invincibility frames
  - `Enemy` - AI-driven, melee/ranged types
  - `Boss` - Multi-phase boss AI
  - `Projectile` - Homing/linear projectiles
- **Components** (`core/components/`):
  - `JoystickComponent` - Virtual joystick with drag/tap
  - `RiveSpriteComponent` - Rive animation wrapper
  - `ParticleComponent` - GPU particle system
  - `CameraShakeEffect` - Screen shake with decay
  - `DamageFlashComponent` - Red screen flash
  - `ScreenTransition` - Fade in/out
  - `HealthBarComponent` - Smooth HP bar
- **Effects** (`core/effects/`):
  - `LiquidEffectComponent` - Fluid splash simulation
  - `GlassEffectComponent` - Shattering shards
  - `FluidSquadEffectComponent` - Blob physics with merge
- **Systems** (`core/systems/`):
  - `AudioSystem` - Music/SFX management
  - `ScoreSystem` - Score, combo, kills tracking
  - `WaveSystem` - Wave state machine
  - `AchievementSystem` - Achievement progression
  - `SkillSystem` - Skill unlock & stat bonuses
  - `LevelSystem` - Level flow management

### 3. UI Layer (`lib/ui/`)

- **Screens** (`ui/screens/`):
  - `MenuScreen` - Animated main menu
  - `GameScreen` - Game widget + HUD overlay
  - `LevelSelectScreen` - Level grid with stars
  - `SettingsScreen` - Audio/graphics options
  - `AchievementsScreen` - Achievement grid
  - `ShopScreen` - Skill tree upgrade
- **Widgets** (`ui/widgets/`):
  - `HUD` - Score, health, wave, combo
  - `PauseMenu` - Blurred pause overlay
  - `GameOverOverlay` - Victory/defeat stats
  - `WaveIndicator` - Wave start animation

## Data Flow

```
User Input → Joystick → Player.moveDirection → updatePhysics()
                                                     ↓
User Input → Attack Button → Player.tryAttack() → Projectile
                                                     ↓
SpawnEngine → Enemy/Boss → CollisionSystem → Damage
                                                     ↓
                                ScoreSystem & AchievementSystem update
                                                     ↓
                                GameState (Provider) → UI rebuild
```

## State Management

- **Provider** for global UI state (screens, settings, progress)
- **Callback chains** within CoreGame (e.g., `onEnemyKilled`)
- **Direct references** for game-time critical systems
