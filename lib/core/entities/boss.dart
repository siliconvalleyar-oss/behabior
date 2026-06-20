import 'dart:math' show atan2, min, pi;
import 'dart:ui' show Canvas, Paint, ColorFilter, BlendMode;
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/engine/collision_system.dart';
import 'package:behabior/core/utils/math_utils.dart';
import 'package:behabior/core/components/rive_sprite_component.dart';

enum BossPhase { phase1, phase2, phase3, enraged }

class Boss extends BaseEntity {
  final String bossType;
  BossPhase _phase = BossPhase.phase1;
  double _attackTimer = 0.0;
  double _specialAttackTimer = 0.0;
  Vector2? _targetPosition;
  double _rageThreshold = 0.3;

  double phase2HealthPercent = 0.6;
  double phase3HealthPercent = 0.3;
  double specialAttackCooldown = 5.0;
  double attackRange = 80.0;
  bool _isEnraged = false;

  void Function(Boss boss)? onDeath;
  void Function(Vector2 position, Vector2 direction, String attackType)? onAttack;
  void Function(Boss boss, BossPhase newPhase)? onPhaseChange;

  RiveSpriteComponent? _riveComponent;
  late final Sprite _sprite;

  Boss({
    required this.bossType,
    Vector2? position,
    double healthMultiplier = 1.0,
  }) : super(
          position: position ?? Vector2.zero(),
          hitboxRadius: 48.0,
          team: EntityTeam.enemy,
          health: 500.0 * healthMultiplier,
          maxHealth: 500.0 * healthMultiplier,
          speed: 60.0,
          damage: 30.0,
          size: Vector2(96.0, 96.0),
        );

  @override
  Future<void> onLoad() async {
    try {
      _sprite = await Sprite.load('assets/images/naves/enemy_02.png');
    } catch (_) {
      try {
        _sprite = await Sprite.load('images/naves/enemy_02.png');
      } catch (_) {}
    }
    try {
      final rive = RiveSpriteComponent(
        assetPath: 'assets/animations/character.riv',
        size: size,
        position: size / 2,
      )..anchor = Anchor.center;
      await rive.load();
      if (rive.isLoaded) {
        _riveComponent = rive;
        add(rive);
      }
    } catch (_) {}
  }

  @override
  void updatePhysics(double dt) {
    if (isDead) return;

    _attackTimer += dt;
    _specialAttackTimer += dt;

    final hpPercent = healthPercent;
    if (hpPercent <= _rageThreshold && !_isEnraged) {
      _enterPhase(BossPhase.enraged);
    } else if (hpPercent <= phase3HealthPercent && _phase == BossPhase.phase2) {
      _enterPhase(BossPhase.phase3);
    } else if (hpPercent <= phase2HealthPercent && _phase == BossPhase.phase1) {
      _enterPhase(BossPhase.phase2);
    }

    if (_targetPosition != null) {
      final dist = distanceTo(_targetPosition!);
      if (dist > attackRange) {
        moveToward(_targetPosition!, dt);
      } else if (_attackTimer >= _getAttackCooldown()) {
        _attackTimer = 0.0;
        _executeAttack();
      }

      if (dist > 1) {
        final dir = _targetPosition! - position;
        angle = atan2(dir.y, dir.x) + pi / 2;
      }
    }
  }

  double _getAttackCooldown() {
    switch (_phase) {
      case BossPhase.phase1:
        return 1.5;
      case BossPhase.phase2:
        return 1.2;
      case BossPhase.phase3:
        return 0.8;
      case BossPhase.enraged:
        return 0.5;
    }
  }

  void _executeAttack() {
    if (_targetPosition == null) return;

    final dir = directionTo(_targetPosition!);
    String attackType = 'basic';

    if (_specialAttackTimer >= specialAttackCooldown) {
      _specialAttackTimer = 0.0;
      attackType = _getSpecialAttack();
    }

    onAttack?.call(position.clone(), dir, attackType);
  }

  String _getSpecialAttack() {
    switch (_phase) {
      case BossPhase.phase1:
        return 'shockwave';
      case BossPhase.phase2:
        return 'spread_shot';
      case BossPhase.phase3:
        return 'laser_beam';
      case BossPhase.enraged:
        return 'meteor_storm';
    }
  }

  void _enterPhase(BossPhase newPhase) {
    _phase = newPhase;
    if (newPhase == BossPhase.enraged) {
      _isEnraged = true;
      speed *= 1.5;
      damage *= 2.0;
    }
    onPhaseChange?.call(this, newPhase);
  }

  void setTarget(Vector2 target) {
    _targetPosition = target;
  }

  @override
  void takeDamage(double amount, {Vector2? from}) {
    super.takeDamage(amount, from: from);
    speed = min(speed * 1.1, 200.0);
  }

  @override
  void onCollision(CollisionInfo info) {
  }

  @override
  void die() {
    super.die();
    onDeath?.call(this);
  }

  BossPhase get phase => _phase;
  bool get isEnraged => _isEnraged;

  @override
  void render(Canvas canvas) {
    final spriteSize = _sprite.srcSize;
    final scale = min(size.x / spriteSize.x, size.y / spriteSize.y);
    final scaled = spriteSize * scale;
    final offset = (size - scaled) / 2;

    final paint = Paint();
    if (_isEnraged) {
      paint.colorFilter = ColorFilter.mode(Colors.red, BlendMode.srcATop);
    }

    _sprite.render(canvas, position: offset, size: scaled, overridePaint: paint);
  }
}
