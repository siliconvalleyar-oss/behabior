import 'dart:math' show atan2, min, pi;
import 'dart:ui' show Canvas, Paint;
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/engine/collision_system.dart';
import 'package:behabior/core/entities/projectile.dart';

class Player extends BaseEntity {
  Vector2 _moveDirection = Vector2.zero();
  double attackCooldown = 0.3;
  double _attackTimer = 0.0;
  bool canMove = true;

  double _invincibilityTimer = 0.0;
  static const double invincibilityDuration = 1.0;
  bool get isInvincible => _invincibilityTimer > 0;

  double damageMultiplier = 1.0;
  double speedMultiplier = 1.0;
  double healthMultiplier = 1.0;

  void Function(Projectile projectile)? onShoot;

  late final Sprite _sprite;

  Player({
    Vector2? position,
  }) : super(
          position: position ?? Vector2.zero(),
          hitboxRadius: GameConfig.playerSize / 2,
          team: EntityTeam.player,
          health: GameConfig.playerMaxHealth,
          maxHealth: GameConfig.playerMaxHealth,
          speed: GameConfig.playerSpeed,
          damage: 25.0,
          size: Vector2(GameConfig.playerSize, GameConfig.playerSize),
        );

  Vector2 get moveDirection => _moveDirection;
  set moveDirection(Vector2 dir) {
    _moveDirection = dir..normalize();
  }

  void applySkillModifiers(double healthBonus, double speedBonus, double damageBonus) {
    maxHealth = GameConfig.playerMaxHealth + healthBonus;
    health = maxHealth;
    speedMultiplier = 1.0 + (speedBonus / GameConfig.playerSpeed);
    damageMultiplier = 1.0 + (damageBonus / 25.0);
  }

  @override
  Future<void> onLoad() async {
    _sprite = await Sprite.load('naves/nave_00.png');
  }

  @override
  void updatePhysics(double dt) {
    if (canMove && _moveDirection.length > 0.1) {
      final effectiveSpeed = speed * speedMultiplier;
      position += _moveDirection * effectiveSpeed * dt;
      state = EntityState.moving;
    } else if (_moveDirection.length <= 0.1) {
      state = EntityState.idle;
    }

    position.setValues(
      position.x.clamp(hitboxRadius, GameConfig.worldWidth - hitboxRadius),
      position.y.clamp(hitboxRadius, GameConfig.worldHeight - hitboxRadius),
    );

    if (_attackTimer > 0) {
      _attackTimer -= dt;
    }

    if (_invincibilityTimer > 0) {
      _invincibilityTimer -= dt;
    }

    if (_moveDirection.length > 0.1) {
      angle = atan2(_moveDirection.y, _moveDirection.x) + pi / 2;
    }
  }

  void tryAttack(Vector2 targetDirection) {
    if (_attackTimer > 0) return;
    _attackTimer = attackCooldown;
    state = EntityState.attacking;

    final projectile = Projectile(
      position: position.clone(),
      direction: targetDirection,
      projectileSpeed: GameConfig.projectileSpeed,
      damage: damage * damageMultiplier,
      team: EntityTeam.player,
      size: GameConfig.projectileSize,
    );
    onShoot?.call(projectile);
  }

  @override
  void takeDamage(double amount, {Vector2? from}) {
    if (isInvincible) return;
    super.takeDamage(amount, from: from);
    _invincibilityTimer = invincibilityDuration;
  }

  @override
  void onCollision(CollisionInfo info) {
    if (info.layerB == CollisionLayer.enemy && !isInvincible) {
      takeDamage(10.0, from: info.normal);
    }
  }

  void reset() {
    health = maxHealth;
    _invincibilityTimer = 0.0;
    state = EntityState.idle;
    _moveDirection = Vector2.zero();
    _attackTimer = 0.0;
  }

  @override
  void render(Canvas canvas) {
    final spriteSize = _sprite.srcSize;
    final scale = min(size.x / spriteSize.x, size.y / spriteSize.y);
    final scaled = spriteSize * scale;
    final offset = (size - scaled) / 2;

    final paint = Paint();
    if (isInvincible) {
      paint.color = Colors.white.withOpacity(0.5);
    }

    _sprite.render(canvas, position: offset, size: scaled, overridePaint: paint);
  }
}
