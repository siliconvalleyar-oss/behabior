import 'package:flame/components.dart';
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/engine/collision_system.dart';

class Projectile extends BaseEntity {
  final Vector2 direction;
  final double projectileSpeed;
  double lifetime = 2.0;
  double _age = 0.0;
  bool hasHit = false;

  // Callbacks
  void Function(Projectile projectile)? onHit;
  void Function(Projectile projectile)? onExpire;

  Projectile({
    Vector2? position,
    required this.direction,
    this.projectileSpeed = GameConfig.projectileSpeed,
    double? damage,
    EntityTeam? team,
    double? size,
  }) : super(
          position: position ?? Vector2.zero(),
          hitboxRadius: (size ?? GameConfig.projectileSize) / 2,
          team: team ?? EntityTeam.player,
          health: 1.0,
          maxHealth: 1.0,
          speed: 0.0,
          damage: damage ?? 10.0,
          size: Vector2(size ?? GameConfig.projectileSize, size ?? GameConfig.projectileSize),
        );

  @override
  void updatePhysics(double dt) {
    if (hasHit || isDead) return;

    _age += dt;
    position += direction * projectileSpeed * dt;

    // Lifetime check
    if (_age >= lifetime) {
      hasHit = true;
      isActive = false;
      onExpire?.call(this);
    }

    // Out of bounds check
    if (position.x < -50 || position.x > GameConfig.worldWidth + 50 ||
        position.y < -50 || position.y > GameConfig.worldHeight + 50) {
      hasHit = true;
      isActive = false;
    }
  }

  @override
  void onCollision(CollisionInfo info) {
    if (hasHit) return;

    // Check layer compatibility
    if ((team == EntityTeam.player && info.layerB == CollisionLayer.enemy) ||
        (team == EntityTeam.player && info.layerB == CollisionLayer.boss) ||
        (team == EntityTeam.enemy && info.layerB == CollisionLayer.player)) {
      hasHit = true;
      isActive = false;
      onHit?.call(this);
    }
  }
}
