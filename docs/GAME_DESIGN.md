# Dino Run — Game Design

## Concept

A minimalist Chrome Dino-inspired runner where the player controls a pixel-art dinosaur avoiding obstacles in an endless desert.

## Core Loop

1. Game starts with "TAP TO START" screen
2. Tap → dino begins running, obstacles spawn
3. Avoid obstacles by jumping (tap/hold for height)
4. Score increases over time, speed ramps up
5. Collision → game over with score + high score
6. Tap → restart

## Design Pillars

- **One-touch gameplay** — accessible to anyone
- **Progressive difficulty** — speed increases naturally
- **Fair** — collision hitboxes are generous (reduced by 40%)
- **Instant restart** — no menus or loading between runs

## Visual Style

- Flat 2D, light background
- Dark gray sprites/shapes
- Monospace score display
- Centered text for game state messages
