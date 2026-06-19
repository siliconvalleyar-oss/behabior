import 'dart:ui';

class GameConfig {
  static const String gameName = 'Behabior';
  static const String version = '1.0.0';

  // World dimensions
  static const double worldWidth = 1600.0;
  static const double worldHeight = 1200.0;

  // Player
  static const double playerSpeed = 200.0;
  static const double playerMaxHealth = 100.0;
  static const double playerSize = 32.0;

  // Projectile
  static const double projectileSpeed = 400.0;
  static const double projectileSize = 8.0;

  // Camera
  static const double cameraZoom = 1.0;
  static const double cameraShakeIntensity = 5.0;
  static const double cameraShakeDuration = 0.15;

  // Spawn
  static const double spawnInterval = 2.0;
  static const int maxEnemies = 30;
  static const int wavesPerLevel = 5;

  // Physics
  static const double gravity = 0.0; // top-down no gravity
  static const int physicsVelocityIterations = 8;
  static const int physicsPositionIterations = 3;

  // Audio
  static const double defaultMusicVolume = 0.5;
  static const double defaultSfxVolume = 0.7;

  // Effects
  static const double damageFlashDuration = 0.1;
  static const double fadeTransitionDuration = 0.5;
  static const Color damageFlashColor = Color(0x66FF0000);

  // Grid
  static const double tileSize = 32.0;

  // Achievement
  static const int achievementPopupDuration = 3;

  // Skills
  static const int maxSkillPoints = 50;
  static const int skillPointsPerLevel = 3;

  private constructor() {}

  static Size get worldSize => Size(worldWidth, worldHeight);
}
