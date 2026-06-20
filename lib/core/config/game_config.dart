class GameConfig {
  GameConfig._();

  static const String gameName = 'Dino Run';

  static const double viewportWidth = 900;
  static const double viewportHeight = 250;
  static const double worldWidth = 900;
  static const double worldHeight = 250;

  static const double groundY = 220;
  static const double groundScrollSpeed = 6.0;

  static const double dinoX = 80;
  static const double dinoWidth = 44;
  static const double dinoHeight = 47;
  static const double dinoY = groundY - dinoHeight;
  static const double jumpVelocity = -12;
  static const double gravity = 0.6;
  static const double minJumpVelocity = -6;

  static const double initialSpeed = 6.0;
  static const double maxSpeed = 16.0;
  static const double speedIncrement = 0.001;

  static const double obstacleSpawnMin = 1.0;
  static const double obstacleSpawnMax = 2.5;

  static const double duckingHeight = 28;
  static const double pterodactylY = groundY - 80;
  static const double pterodactylLowY = groundY - 40;
}
