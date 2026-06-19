# Behabior - Components Reference

## Core Components

### `JoystickComponent`
- Virtual joystick with drag/tap support
- Position: bottom-left (120, screenH-120)
- Callback: `onDirectionChanged(Vector2 direction)`
- Visual: Background circle + knob + direction indicator

### `RiveSpriteComponent`
- Wraps Rive `.riv` animations
- State machine inputs: speed, direction, attack, hit, death
- Usage: `RiveSpriteComponent(assetPath: 'animations/player.riv')`

### `ParticleComponent`
- Emitter types: burst, stream, fountain, explosion
- Prefabs: `emitExplosion()`, `emitBlood()`, `emitGlassShard()`
- Physics: velocity, drag, alpha fade

### `CameraShakeEffect`
- Intensity decay over duration
- Random offset each frame
- Attached to CameraComponent

### `DamageFlashComponent`
- Red overlay flash
- Configurable duration and color

### `ScreenTransition`
- Fade in, fade out, fade in-out
- Callback on complete

### `HealthBarComponent`
- Smooth HP transition (lerp)
- Color: green > yellow > red
- Optional background and border

## Effect Components

### `LiquidEffectComponent`
- Splash simulation with viscosity
- Methods: `spawnSplash()`, `spawnPool()`
- Fluid physics: drag, gravity

### `GlassEffectComponent`
- Shatter physics with random polygon shards
- Method: `breakGlass(position)`
- Edge highlighting

### `FluidSquadEffectComponent`
- Blob physics with merge behavior
- Methods: `spawnBlob()`, `spawnFluidPool()`, `spawnLiquidTrail()`
- Surface tension simulation

## Entity Components

### `BaseEntity`
- Position, health, state machine
- Mixin: `HasHitboxCollision`
- States: idle, moving, attacking, damaged, dying, dead

### `Player`
- Movement, attack, invincibility frames
- Skills: health/speed/damage multipliers
- Collision callback for damage

### `Enemy`
- AI: chase player, melee/ranged
- Death callback with particle effects
- Collision cooldown

### `Boss`
- Multi-phase AI (4 phases)
- Special attacks: shockwave, spread shot, laser, meteor
- Phase change callbacks

### `Projectile`
- Linear movement, lifetime limit
- Team-based collision filtering
- Hit/expire callbacks
