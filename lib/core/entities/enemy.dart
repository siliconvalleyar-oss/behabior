import 'dart:math' show atan2, min, pi;
import 'dart:ui' show Canvas, Paint;
import 'package:flame/components.dart';
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/engine/collision_system.dart';
import 'package:behabior/data/models/enemy_model.dart';
import 'package:behabior/core/components/rive_sprite_component.dart';

class Enemy extends BaseEntity {
  final EnemyModel model;
  double attackRange = 0.0;
  double _attackCooldownTimer = 0.0;
  bool _hasDealtCollisionDamage = false;

  Vector2? _targetPosition;
  bool _isRanged = false;

  void Function(Enemy enemy)? onDeath;
  void Function(Vector2 position, Vector2 direction)? onRangedAttack;

  RiveSpriteComponent? _riveComponent;
  late final Sprite _sprite;

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

  String get _spritePath {
    switch (model.type) {
      case EnemyType.basic:
        return 'naves/enemy_00.png';
      case EnemyType.fast:
        return 'naves/enemy_01.png';
      case EnemyType.tank:
        return 'naves/enemy_02.png';
      case EnemyType.ranged:
        return 'naves/enemy_02.png';
      case EnemyType.healer:
        return 'naves/enemy_00.png';
      case EnemyType.explosive:
        return 'naves/enemy_02.png';
    }
  }

  String get _riveAssetPath {
    switch (model.type) {
      case EnemyType.basic:
      case EnemyType.healer:
        return 'animations/centaur.riv';
      case EnemyType.fast:
        return 'animations/stasher.riv';
      case EnemyType.tank:
      case EnemyType.ranged:
      case EnemyType.explosive:
        return 'animations/character.riv';
    }
  }

  @override
  Future<void> onLoad() async {
    _sprite = await Sprite.load(_spritePath);
    final rive = RiveSpriteComponent(
      assetPath: _riveAssetPath,
      size: size * 0.8,
    )..anchor = Anchor.center;
    await rive.load();
    if (rive.isLoaded) {
      _riveComponent = rive;
      add(rive);
    }
  }

  void setTarget(Vector2 target) {
    _targetPosition = target;
  }

  @override
  void updatePhysics(double dt) {
    if (isDead) return;

    if (_attackCooldownTimer > 0) {
      _attackCooldownTimer -= dt;
    }

    if (_targetPosition != null) {
      final dist = distanceTo(_targetPosition!);
      if (_isRanged && dist <= attackRange) {
        state = EntityState.attacking;
        if (_attackCooldownTimer <= 0) {
          _attackCooldownTimer = model.attackCooldown;
          final dir = directionTo(_targetPosition!);
          onRangedAttack?.call(position.clone(), dir);
        }
      } else if (dist > hitboxRadius + 5) {
        moveToward(_targetPosition!, dt);
      } else {
        state = EntityState.attacking;
        if (_attackCooldownTimer <= 0) {
          _attackCooldownTimer = model.attackCooldown;
        }
      }

      if (dist > 1) {
        final dir = _targetPosition! - position;
        angle = atan2(dir.y, dir.x) + pi / 2;
      }
    }
  }

  @override
  void onCollision(CollisionInfo info) {
    if (info.layerB == CollisionLayer.player && !_hasDealtCollisionDamage) {
      _hasDealtCollisionDamage = true;
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

  @override
  void render(Canvas canvas) {
    if (_riveComponent != null && _riveComponent!.isLoaded) return;
    final spriteSize = _sprite.srcSize;
    final scale = min(size.x / spriteSize.x, size.y / spriteSize.y);
    final scaled = spriteSize * scale;
    final offset = (size - scaled) / 2;

    final paint = Paint();
    _sprite.render(canvas, position: offset, size: scaled, overridePaint: paint);
  }
}
