# Behabior - Systems Documentation

## `CoreGame` (Main Game Loop)

Extends `FlameGame` with `HasTappables` and `HasDraggables`.

### Update Order (per frame)
1. Camera shake
2. Score system (combo timer)
3. Player physics + health bar
4. Enemy AI (target player, move, attack)
5. Boss AI (phase check, attack patterns)
6. Projectile movement + collision
7. Cleanup dead entities
8. Collision system
9. Spawn engine (wave logic)
10. Check game over / level complete

## `SpawnEngine`

### States
```
Idle → Spawning → Wave Active → Wave Complete → Next Wave → All Complete
```

### Configuration
- Wave list from LevelModel
- Per-wave: enemyCount, enemyType, spawnInterval, hasBoss
- Random edge-based spawn positions

## `CollisionSystem`

Circle-based overlap detection with layer filtering.

### Collision Layers
- `player` - Player entity
- `enemy` - Enemy entities
- `projectile` - Projectiles
- `boss` - Boss entities
- `obstacle` - Environment
- `pickup` - Item pickups

### Collision Matrix
| | player | enemy | projectile | boss |
|---|--------|-------|------------|------|
| player | - | Damage | - | Damage |
| enemy | Damage | - | Hit | - |
| projectile | - | Hit | - | Hit |
| boss | Damage | - | Hit | - |

## `AudioSystem`

### Music
- `theme.mp3` - Menu
- `battle.mp3` - Normal combat
- `boss.mp3` - Boss encounter

### SFX
- shoot, hit, explosion, enemy_death, player_hit
- level_up, achievement, button_click, glass_break
- wave_start, boss_warning, pickup

### Features
- Independent music/SFX volume (0.0-1.0)
- Toggle on/off
- BGM pooling

## `ScoreSystem`

- Points per kill = enemyHP * 2 * comboMultiplier
- Combo: +10% per kill (3s timeout)
- Boss kill = bossHP * 3
- Time bonus = timeRemaining * 10
- High score tracking

## `WaveSystem`

States: waiting → starting → active → completed → allCompleted

## `AchievementSystem`

8 achievements with progress tracking.
Auto-popup when unlocked (3s duration).

## `SkillSystem`

6 skills (3 passive, 2 active, 1 ultimate).
Prerequisite checking, stat computation.
