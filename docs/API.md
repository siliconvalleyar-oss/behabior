# Dino Run — API

## Public Interface

### `DinoGame`

```dart
class DinoGame extends FlameGame {
  bool get gameStarted;
  bool get gameOver;
  ScoreSystem get scoreSystem;

  void handleTap();
  void handleRelease();
  void startGame();
}
```

### `Dino`

```dart
class Dino extends PositionComponent {
  DinoState dinoState; // running, jumping, dead
  double velocityY;

  void jump();
  void releaseJump();
  void die();
  void updatePhysics(double dt);
}
```

### `Obstacle`

```dart
class Obstacle extends PositionComponent {
  ObstacleType type;    // cactus, cactusDouble, pterodactyl
  bool passed;
  bool get isOffScreen;

  void move(double speed, double dt);
  factory Obstacle.random(double speed);
}
```

### `ScoreSystem`

```dart
class ScoreSystem {
  int score;
  int highScore;
  double speed;

  void update(double dt);
  void reset();
  void checkHighScore();
}
```
