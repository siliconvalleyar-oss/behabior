import 'dart:math';
import 'package:flame/components.dart';
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/engine/collision_system.dart';
import 'package:behabior/data/models/enemy_model.dart';

class Enemy extends BaseEntity {
  final EnemyModel model;
  double attackRange = 0.0;
  double _attackCooldownTimer = 0.0;
  bool _hasDealtCollisionDamage = false;

  // AI state
  Vector2? _targetPosition;
  bool _isRanged = false;

  // Callbacks
  void Function(Enemy enemy)? onDeath;
  void Function(Vector2 position, Vector2 direction)? onRangedAttack;

  Enemy({
    required this.model,
    Vector2? position,
  }) : super(
          position: position ?? Vector2.zero(),
          hitboxRadius: model.size / 2,
          team: EntityTeam.enemy,
          health: model.health,
          maxHealth: model.health,
          speed: model.speed,
          damage: model.damage,
          size: Vector2(model.size, model.size),
        ) {
    attackRange = model.attackRange;
    _isRanged = model.projectileType != null;
  }

  void setTarget(Vector2 target) {
    _targetPosition = target;
  }

  @override
  void updatePhysics(double dt) {
    if (isDead) return;

    // Cooldown
    if (_attackCooldownTimer > 0) {
      _attackCooldownTimer -= dt;
    }

    // AI behavior
    if (_targetPosition != null) {
      final dist = distanceTo(_targetPosition!);
      if (_isRanged && dist <= attackRange) {
        // Ranged attack
        state = EntityState.attacking;
        if (_attackCooldownTimer <= 0) {
          _attackCooldownTimer = model.attackCooldown;
          final dir = directionTo(_targetPosition!);
          onRangedAttack?.call(position.clone(), dir);
        }
      } else if (dist > hitboxRadius + 5) {
        // Move toward target
        moveToward(_targetPosition!, dt);
      } else {
        // Melee range
        state = EntityState.attacking;
        if (_attackCooldownTimer <= 0) {
          _attackCooldownTimer = model.attackCooldown;
        }
      }
    }
  }

  @override
  void onCollision(CollisionInfo info) {
    if (info.layerB == CollisionLayer.player && !_hasDealtCollisionDamage) {
      _hasDealtCollisionDamage = true;
      // Damage dealt via collision system
    }
  }

  @override
  void die() {
    super.die();
    onDeath?.call(this);
  }

  void resetCollisionFlag() {
    _hasDealtCollisionDamage = false;
  }
}
