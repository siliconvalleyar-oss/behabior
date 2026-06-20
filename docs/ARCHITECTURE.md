# Dino Run — Architecture

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp
├── core/
│   ├── dino_game.dart           # Main FlameGame (update, render, collision, spawn)
│   ├── config/
│   │   └── game_config.dart     # Constants (gravity, speed, sizes)
│   ├── entities/
│   │   ├── dino.dart            # Player (jump, run animation, die)
│   │   ├── obstacle.dart        # Cactus & pterodactyl obstacles
│   │   ├── ground.dart          # Scrolling ground line
│   │   └── cloud.dart           # Decorative scrolling clouds
│   └── systems/
│       └── score_system.dart    # Score, speed, high score
└── ui/
    ├── screens/
    │   └── game_screen.dart     # Flutter wrapper with Listener
    └── themes/
        └── app_theme.dart       # Minimal theme
```

## Data Flow

```
Listener (touch) → DinoGame.handleTap() → Dino.jump()
Game loop (dt)   → update() → physics, spawn, collision, scoring
render()         → Canvas → text, sprites, ground, obstacles, clouds
```
