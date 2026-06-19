# Behabior - Game Design Document

## Concept

Top-down pixel defender where players fight waves of enemies using virtual joystick controls. Features Rive-animated characters, fluid/glass effects, and deep progression.

## Core Mechanics

### Movement
- Virtual joystick (left side) for 8-directional movement
- Smooth acceleration/deceleration
- World clamped to bounds

### Combat
- Tap attack button (right side) to shoot projectiles
- Auto-aim toward move direction
- Cooldown-based firing
- Damage modifiers from skills

### Waves
- Each level has 3-8 waves
- Enemies spawn at random positions around screen edge
- Boss waves every 3-5 waves
- Wave complete = score bonus
- All waves cleared = level complete

## Enemy Types

| Type | HP | Speed | Behavior |
|------|----|-------|----------|
| Grunt | 30 | 80 | Chase player, melee |
| Runner | 15 | 160 | Fast, low HP |
| Brute | 120 | 40 | Slow, high damage |
| Sniper | 20 | 50 | Ranged attacks |
| Medic | 25 | 70 | Heals nearby enemies |
| Bomber | 10 | 90 | Explodes on death |

## Boss Phases

Bosses transition through 4 phases (HP thresholds):
1. **Phase 1** (100-60%) - Basic attacks
2. **Phase 2** (60-30%) - Spread shots
3. **Phase 3** (30-0%) - Laser beams
4. **Enraged** (<30%) - Double speed/damage, meteor storm

## Skill Tree

| Skill | Type | Effect |
|-------|------|--------|
| Vitality | Passive | +25 HP/level |
| Swift | Passive | +15 speed/level |
| Power | Passive | +5 damage/level |
| Barrier | Active | +1s shield/level |
| Berserker | Active | +0.5x atk speed/level |
| Nova Blast | Ultimate | +25 AoE damage/level |

## Achievement System

8 achievements tracking kills, waves, bosses, skills, and secrets.

## Progression

- XP per kill → Level up → Skill points
- Stars per level (1-3 based on HP remaining)
- Skill points unlock/upgrade skills
- Achievements give reward points

## Visual Design

- Dark theme with neon accents (#6C5CE7 purple primary)
- Glass-morphism UI panels
- Particle effects for combat feedback
- Screen shake on impacts
- Fluid dynamics for liquid effects
- Shatter physics for glass obstacles
- Smooth screen transitions (fade in/out)
