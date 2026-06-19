# Behabior - API Reference

## Public API

### `GameState` (Provider)

```dart
// Navigation
void navigateTo(GameScreen screen)

// Levels
void startLevel(int levelId)
Future<void> completeLevel(int levelId, int stars)

// Skills
bool upgradeSkill(String skillId)

// Audio
void setMusicVolume(double vol)
void setSfxVolume(double vol)

// Getters
GameScreen currentScreen
int playerLevel
int playerXp
int skillPoints
int totalKills
double musicVolume
double sfxVolume
List<LevelModel> levels
List<SkillModel> skills
bool isInitialized
```

### `CoreGame` (FlameGame)

```dart
// Lifecycle
Future<void> onLoad()
void initializeLevel(int levelId, LevelModel level)
void dispose()

// Controls
void performAttack(Vector2 targetDirection)
void togglePause()

// Callbacks
void Function(int levelId, int stars)? onLevelComplete
void Function()? onGameOver

// State
bool isPaused
bool isGameOver
bool isLevelComplete
Player? player
```

### `AudioSystem`

```dart
Future<void> init()
void playMusic(String key, {bool loop})
void stopMusic()
void playSfx(String key, {double? volume})
void playShoot() / playHit() / playExplosion() / etc.
void setMusicVolume(double vol)
void setSfxVolume(double vol)
void toggleMusic() / toggleSfx()
```

### `CollisionSystem`

```dart
void add(HasHitboxCollision collidable)
void remove(HasHitboxCollision collidable)
void update(double dt) // Process all collisions
void clear()
```

### `SpawnEngine`

```dart
void loadWaves(List<SpawnWave> waves)
void start()
void update(double dt, Vector2 playerPosition)
void pause() / resume()
void reset()

// Callbacks
void Function(Enemy)? onEnemySpawned
void Function(Boss)? onBossSpawned
void Function(int wave)? onWaveStarted
void Function(int wave)? onWaveComplete
void Function()? onAllWavesComplete
```

### `ParticleComponent`

```dart
void emit({position, type, count, color, speed, lifetime, size, radius})
void emitExplosion(Vector2 position, {color, radius})
void emitBlood(Vector2 position)
void emitGlassShard(Vector2 position)
void stop()
void clear()
```

### `ScreenTransition`

```dart
void startFadeIn({duration, onComplete, color})
void startFadeOut({duration, onComplete, color})
void startFadeInOut({duration, holdDuration, onComplete, color})

// Getters
bool isActive
double progress
```

### Rive Animations

All `.riv` animations should export a State Machine with:
- `speed` (number) - Animation blend
- `direction` (number 0-360) - Rotation
- `attack` (trigger) - Attack animation
- `hit` (trigger) - Damage reaction
- `death` (trigger) - Death animation

### Save Keys

| Key | Type | Description |
|-----|------|-------------|
| `behabior_levels` | JSON list | Level progress |
| `behabior_achievements` | JSON list | Achievement progress |
| `behabior_skills` | JSON list | Skill levels |
| `behabior_settings` | JSON map | Audio/graphics settings |
| `behabior_player` | JSON map | Player XP, level, kills |
| `behabior_music_volume` | double | Music volume 0-1 |
| `behabior_sfx_volume` | double | SFX volume 0-1 |
| `behabior_player_level` | int | Player level |
| `behabior_player_xp` | int | Player XP |
| `behabior_total_kills` | int | Lifetime kills |
| `behabior_skill_points` | int | Available points |
