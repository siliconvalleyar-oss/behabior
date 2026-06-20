# Dino Run — Systems

## ScoreSystem (`lib/core/systems/score_system.dart`)

- `score` — current score, increments by 10 per obstacle passed
- `highScore` — best score (session only)
- `speed` — current scroll speed, increases every 100 points

### Speed Progression

- Start: `6.0`
- Max: `18.0`
- Formula: `initialSpeed + (score / 100) * 0.5`

### Methods

- `update(dt)` — delta time base (unused currently)
- `reset()` — reset score and speed
- `checkHighScore()` — update high score if current is higher
