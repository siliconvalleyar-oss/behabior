# Behabior - Skill System

## Overview

6 skills in 3 categories: **Passive**, **Active**, and **Ultimate**.
Skill points are earned by leveling up (3 points per level, max 50).

## Skill Tree

### Passive Skills

| Skill | ID | Base Effect | Per Level | Max Level | Cost |
|-------|----|-------------|-----------|-----------|------|
| Vitality | `health_boost` | +100 HP | +25 HP | 5 | 1 pt |
| Swift | `speed_boost` | +30 speed | +15 speed | 5 | 1 pt |
| Power | `damage_boost` | +5 damage | +5 damage | 5 | 1 pt |

### Active Skills

| Skill | ID | Base Effect | Per Level | Max Level | Cost |
|-------|----|-------------|-----------|-----------|------|
| Barrier | `barrier` | 1s shield | +1s duration | 3 | 2 pt |
| Berserker | `berserker` | 0.5x atk speed | +0.5x bonus | 3 | 2 pt |

### Ultimate Skills

| Skill | ID | Base Effect | Per Level | Max Level | Cost |
|-------|----|-------------|-----------|-----------|------|
| Nova Blast | `nova_blast` | 50 AoE dmg | +25 dmg/level | 3 | 3 pt |

## Stat Computation

```
player.maxHealth = baseHealth + (healthBoostLevel * 25)
player.speed      = baseSpeed  + (speedBoostLevel  * 15)
player.damage     = baseDamage + (damageBoostLevel * 5)
player.shieldDuration = 1 + (barrierLevel * 1)
player.attackSpeed    = baseSpeed * (1 + berserkerLevel * 0.5)
player.novaDamage     = 50 + (novaBlastLevel * 25)
```

## Prerequisites

| Skill | Requires |
|-------|----------|
| Barrier | Vitality Lv.2 |
| Berserker | Power Lv.2 |
| Nova Blast | Barrier Lv.1 + Berserker Lv.1 |

## Implementation

- `SkillModel` — data class with id, name, level, maxLevel
- `SkillSystem` — computes stat bonuses
- `ShopScreen` — UI for buying/upgrading
- `GameState` — persists skill levels via `SaveRepository`

## Save Format

```json
{
  "health_boost": { "currentLevel": 2 },
  "speed_boost": { "currentLevel": 1 },
  "damage_boost": { "currentLevel": 3 },
  "barrier": { "currentLevel": 1 },
  "berserker": { "currentLevel": 0 },
  "nova_blast": { "currentLevel": 0 }
}
```
