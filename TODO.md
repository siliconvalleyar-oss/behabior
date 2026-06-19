# Behabior - TODO

## 🔴 High Priority (Build Fixes)

- [ ] **Fix Flame API compatibility** — update code for Flame 1.37+ (HasTappables, HasDraggables, CameraComponent, Viewport, JoystickComponent)
- [ ] **Fix Vector2 imports** — resolve conflict between `vector_math` and `vector_math_64` across all files
- [ ] **Add missing `dart:ui`/`dart:math` imports** — Colors, atan2, cos, sin not imported
- [ ] **Fix GameScreen enum conflict** — rename or disambiguate between `game_state.dart` and `game_screen.dart`
- [ ] **Fix `private constructor()` syntax** — replace with `GameConfig._()`
- [ ] **Fix `private-named-parameters`** — update HealthBar or set SDK to 3.12+
- [ ] **Fix `EnemyModel` / `EntityTeam` imports** in `core_game.dart`
- [ ] **Fix missing Icon constants** — `Icons.crosshair`, `Icons.explosion`, `Icons.menu`
- [ ] **Fix `Bgm.setVolume`** — API changed in flame_audio 2.x
- [ ] **Fix `Projectile.isActive` setter** — missing or renamed property
- [ ] **Fix `Projectile.speed` parameter** — renamed/removed in constructor
- [ ] **Fix `SpawnEngine` instantiation in game_screen.dart**
- [ ] **Fix `CollisionSystem` type mismatch** — `HasHitboxCollision` not implemented correctly

## 🟡 Medium Priority (Features)

- [ ] **Add missing asset files** — Rive animations (.riv), audio (.mp3/.wav), images (.png)
- [ ] **Fix `wave_indicator.dart`** — missing `TweenSequence` animation
- [ ] **Complete wave system** — wire up SpawnEngine ⇄ WaveSystem properly
- [ ] **Add background rendering** — draw world/level backgrounds
- [ ] **Implement skill tree UI** — connect shop to SkillSystem
- [ ] **Implement save/load** — verify SharedPreferences integration
- [ ] **Add game over flow** — stats display, retry/quit buttons

## 🟢 Low Priority (Polish)

- [ ] **Add particle textures** — replace placeholder circle particles with sprites
- [ ] **Add screen transitions** — ensure fade in/out works between screens
- [ ] **Add camera shake** — verify decay and intensity
- [ ] **Add HUD animations** — wave indicator, combo counter
- [ ] **Test on device** — verify touch controls and performance
- [ ] **Optimize collision system** — spatial partitioning for many entities
- [ ] **Add localization** — string resources for Spanish/English
