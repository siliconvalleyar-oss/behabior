import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/data/providers/game_state.dart';

class Player extends BaseEntity {
  final GameState _gameState;
  Vector2 moveDirection = Vector2.zero();
  Vector2 lastDirection = Vector2(0, -1);
  double attackCooldownTimer = 0;
  bool canTakeDamage = true;
  double _invincibilityTimer = 0;

  Player(this._gameState)
      : super(
          size: Vector2.all(GameConfig.playerSize),
          currentHealth: GameConfig.playerMaxHealth +
              (_gameState.getSkillBonuses()['maxHealth'] ?? 0),
          maxHealth: GameConfig.playerMaxHealth +
              (_gameState.getSkillBonuses()['maxHealth'] ?? 0),
          speed: GameConfig.playerSpeed +
              (_gameState.getSkillBonuses()['speed'] ?? 0),
        ) {
    position.setValues(GameConfig.worldWidth / 2, GameConfig.worldHeight / 2);
  }

  @override
  void onStateChanged(EntityState newState) {}

  @override
  void updatePhysics(double dt) {
    if (!active) return;
    if (_invincibilityTimer > 0) {
      _invincibilityTimer -= dt;
      if (_invincibilityTimer <= 0) {
        _invincibilityTimer = 0;
        canTakeDamage = true;
      }
    }

    if (moveDirection.length > 0.1) {
      final dir = moveDirection.normalized();
      lastDirection.setValues(dir.x, dir.y);
      position.add(dir * speed * dt);
      position.clamp(
        Vector2(0, 0),
        Vector2(GameConfig.worldWidth, GameConfig.worldHeight),
      );
      state = EntityState.moving;
    } else {
      state = EntityState.idle;
    }

    if (attackCooldownTimer > 0) {
      attackCooldownTimer -= dt;
    }
  }

  bool canFire() => attackCooldownTimer <= 0;

  void fire() {
    attackCooldownTimer = GameConfig.attackCooldown;
  }

  @override
  void takeDamage(double amount) {
    if (!canTakeDamage) return;
    super.takeDamage(amount);
    canTakeDamage = false;
    _invincibilityTimer = GameConfig.playerInvincibilityDuration;
  }

  void takeContactDamage(double amount) {
    takeDamage(amount);
  }

  @override
  void reset() {
    super.reset();
    position.setValues(GameConfig.worldWidth / 2, GameConfig.worldHeight / 2);
    moveDirection = Vector2.zero();
    lastDirection = Vector2(0, -1);
    attackCooldownTimer = 0;
    canTakeDamage = true;
    _invincibilityTimer = 0;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF6C5CE7);
    canvas.drawCircle(Offset.zero, size.x / 2, paint);

    if (!canTakeDamage && _invincibilityTimer > 0) {
      final flash = (sin(_invincibilityTimer * 8)).abs();
      final flashPaint = Paint()
        ..color = Color.fromARGB((flash * 128).toInt(), 255, 255, 255);
      canvas.drawCircle(Offset.zero, size.x / 2 + 2, flashPaint);
    }

    final dirPaint = Paint()..color = const Color(0xFFA29BFE);
    final dx = lastDirection.x * size.x / 2;
    final dy = lastDirection.y * size.y / 2;
    canvas.drawLine(Offset.zero, Offset(dx, dy), dirPaint..strokeWidth = 2);
  }
}
