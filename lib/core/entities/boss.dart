import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/entities/player.dart';

class Boss extends BaseEntity {
  final String _bossType;
  double phase = 1;
  int _attackIndex = 0;
  double _attackTimer = 0;
  double _phaseChangeTimer = 0;
  bool hasDroppedLoot = false;
  bool isContactAttacking = false;

  final List<BossAttack> _patterns = [];

  String get type => _bossType;

  Boss(Map<String, double> bonuses)
      : _bossType = 'phase_boss',
        super(
          size: Vector2.all(64),
          currentHealth: 500 + (bonuses['bossHealth'] ?? 0),
          maxHealth: 500 + (bonuses['bossHealth'] ?? 0),
          speed: 50,
          contactDamage: 15,
        ) {
    position.setValues(400, 100);
    _initPatterns();
  }

  void _initPatterns() {
    _patterns.addAll([
      BossAttack('shockwave', 2.0, 25),
      BossAttack('spread_shot', 3.0, 15),
      BossAttack('laser_beam', 1.5, 30),
      BossAttack('meteor_storm', 4.0, 20),
    ]);
  }

  void updateAI(Player player, double dt) {
    if (!active) return;

    final hpPercent = currentHealth / maxHealth;
    if (hpPercent <= 0.3 && phase < 3) {
      phase = 3;
      _phaseChangeTimer = 1.0;
    } else if (hpPercent <= 0.6 && phase < 2) {
      phase = 2;
      _phaseChangeTimer = 1.0;
    }

    if (_phaseChangeTimer > 0) {
      _phaseChangeTimer -= dt;
      return;
    }

    final dir = player.position - position;
    final dist = dir.length;

    if (dist > 200) {
      final movement = dir.normalized() * speed * dt;
      position.add(movement);
      state = EntityState.moving;
    } else {
      state = EntityState.attacking;
    }

    _attackTimer += dt;
    final interval = _patterns[_attackIndex % _patterns.length].interval / phase;
    if (_attackTimer >= interval) {
      _attackTimer = 0;
      _attackIndex++;
    }
  }

  @override
  void onDeath() {
    active = false;
    hasDroppedLoot = false;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFE74C3C)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, size.x / 2, paint);

    final phasePaint = Paint()
      ..color = phase == 1
          ? const Color(0xFFF39C12)
          : phase == 2
              ? const Color(0xFFE74C3C)
              : const Color(0xFF8E44AD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset.zero, size.x / 2, phasePaint);

    final hpStrip = (currentHealth / maxHealth);
    final hpPaint = Paint()..color = const Color(0xFF2ECC71);
    canvas.drawRect(
      const Offset(-20, -36) & const Size(40, 4),
      hpPaint..color = const Color(0xFF2ECC71),
    );
    canvas.drawRect(
      const Offset(-20, -36) & Size(40 * hpStrip, 4),
      hpPaint..color = const Color(0xFF27AE60),
    );

    if (_phaseChangeTimer > 0) {
      final flash = Paint()..color = const Color(0x44FFFFFF);
      canvas.drawCircle(Offset.zero, size.x / 2 + 5, flash);
    }
  }
}

class BossAttack {
  final String name;
  final double interval;
  final double damage;

  BossAttack(this.name, this.interval, this.damage);
}
