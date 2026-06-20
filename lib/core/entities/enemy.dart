import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/data/models/enemy_model.dart';

class Enemy extends BaseEntity {
  final String type;
  final EnemyModel _model;
  bool isRanged;

  Enemy(String type, Map<String, double> bonuses)
      : type = type,
        _model = EnemyModel.presets[type] ?? EnemyModel.presets['grunt']!,
        isRanged = (EnemyModel.presets[type]?.isRanged ?? false),
        super(
          size: Vector2.all(EnemyModel.presets[type]?.spriteSize ?? 28),
          currentHealth: (EnemyModel.presets[type]?.health ?? 30) +
              (bonuses['enemyHealth'] ?? 0),
          maxHealth: (EnemyModel.presets[type]?.health ?? 30) +
              (bonuses['enemyHealth'] ?? 0),
          speed: (EnemyModel.presets[type]?.speed ?? 80) +
              (bonuses['enemySpeed'] ?? 0),
          contactDamage: EnemyModel.presets[type]?.contactDamage ?? 5,
        );

  @override
  void onDeath() {
    active = false;
  }

  void updateAI(Vector2 playerPosition, double dt) {
    if (!active) return;

    final dir = playerPosition - position;
    final dist = dir.length;

    if (isRanged && dist < 300) {
      state = EntityState.attacking;
    } else if (dist > 10) {
      final movement = dir.normalized() * speed * dt;
      position.add(movement);
      state = EntityState.moving;
    } else {
      state = EntityState.idle;
    }
  }

  @override
  void render(Canvas canvas) {
    final colors = <String, Color>{
      'grunt': const Color(0xFFE74C3C),
      'runner': const Color(0xFFF39C12),
      'brute': const Color(0xFF8E44AD),
      'sniper': const Color(0xFF3498DB),
      'medic': const Color(0xFF2ECC71),
      'bomber': const Color(0xFFE67E22),
    };
    final color = colors[type] ?? const Color(0xFFE74C3C);
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset.zero, size.x / 2, paint);

    if (state == EntityState.attacking) {
      final flash = Paint()..color = const Color(0x66FFFFFF);
      canvas.drawCircle(Offset.zero, size.x / 2 + 3, flash);
    }
  }
}
