import 'dart:ui';

class GameConfig {
  GameConfig._();

  static const String gameName = 'Behabior';

  static const double worldWidth = 1600.0;
  static const double worldHeight = 1200.0;
  static const double viewportWidth = 800.0;
  static const double viewportHeight = 600.0;

  static const double playerSpeed = 200.0;
  static const double playerMaxHealth = 100.0;
  static const double playerSize = 32.0;
  static const double playerInvincibilityDuration = 1.0;
  static const double attackCooldown = 0.3;

  static const double projectileSpeed = 400.0;
  static const double projectileSize = 8.0;
  static const double projectileLifetime = 1.6;

  static const double cameraZoom = 1.0;
  static const double cameraShakeIntensity = 5.0;
  static const double cameraShakeDuration = 0.15;

  static const double spawnInterval = 2.0;
  static const int maxEnemies = 30;
  static const int wavesPerLevel = 5;
  static const double spawnMargin = 50.0;
  static const double despawnRadius = 900.0;

  static const double enemyContactCooldown = 0.5;

  static const double damageFlashDuration = 0.1;
  static const double fadeTransitionDuration = 0.5;
  static const Color damageFlashColor = Color(0x66FF0000);
  static const Color screenTransitionColor = Color(0xFF000000);

  static const Color primaryColor = Color(0xFF6C5CE7);
  static const Color backgroundColor = Color(0xFF14141C);

  static const int skillPointsPerLevel = 3;
  static const int maxSkillPoints = 50;
}
