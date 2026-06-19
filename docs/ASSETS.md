# Behabior - Asset Pipeline

## Rive Animations (.riv)

Download from [Rive Community](https://rive.app/community/) or create in Rive editor.

### Required Animations

| File | State Machine Inputs |
|------|---------------------|
| `player.riv` | speed, direction, attack, hit, death |
| `enemy_basic.riv` | speed, direction, hit, death |
| `enemy_fast.riv` | speed, direction, hit, death |
| `enemy_tank.riv` | speed, direction, hit, death |
| `enemy_ranged.riv` | speed, direction, attack, hit, death |
| `enemy_healer.riv` | speed, direction, heal, hit, death |
| `enemy_explosive.riv` | speed, direction, hit, death, explode |
| `boss.riv` | phase, attack_type, hit, death |
| `projectile.riv` | - (static sprite) |

### State Machine Convention

All characters should export a State Machine named `"State Machine"` with:
- `speed` (number 0-1) - Movement speed
- `direction` (number 0-360) - Facing angle
- `attack` (trigger) - Attack animation
- `hit` (trigger) - Damage reaction
- `death` (trigger) - Death animation
- `heal` (trigger, optional) - Healing animation

## Audio Assets

### Music
- `theme.mp3` - Main menu theme (loop)
- `battle.mp3` - Combat theme (loop)
- `boss.mp3` - Boss encounter theme (loop)

### SFX
All `.wav` format, 16-bit 44100Hz mono:
- `shoot.wav` - Player projectile fire
- `hit.wav` - Bullet impact
- `explosion.wav` - Explosion
- `enemy_death.wav` - Enemy destroyed
- `player_hit.wav` - Player takes damage
- `level_up.wav` - Level up jingle
- `achievement.wav` - Achievement unlocked
- `button_click.wav` - UI interaction
- `glass_break.wav` - Glass obstacle shattered
- `wave_start.wav` - Wave begin alert
- `boss_warning.wav` - Boss spawn alert
- `pickup.wav` - Item collection

## Image Assets

### Backgrounds
- `backgrounds/level_1.png` through `level_5.png` (1600x1200)

### UI
- `ui/logo.png` - Game logo
- `ui/button_bg.png` - Button background
- `ui/panel_bg.png` - Panel background
- `ui/icon_*.png` - Various icons

### Sprites (legacy fallback)
- `sprites/player_idle.png`
- `sprites/enemy_*.png`

## Asset Loading

Assets are loaded via `FlameAudio.audioCache.loadAll()` and `rive.RiveFile.asset()`.

For development, missing assets will log warnings but won't crash the game.
