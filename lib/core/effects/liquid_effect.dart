import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class LiquidEffectComponent extends PositionComponent {
  final List<LiquidDrop> _drops = [];
  final Random _random = Random();

  void splash({required Vector2 position, int count = 8}) {
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 80 + _random.nextDouble() * 120;
      _drops.add(LiquidDrop(
        position: position.clone(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        lifetime: 0.6 + _random.nextDouble() * 0.4,
        color: const Color(0xFF6C5CE7),
        size: 3 + _random.nextDouble() * 5,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final d in _drops) {
      if (d.alive) {
        d.position.add(d.velocity * dt);
        d.velocity.y += 200 * dt;
        d.age += dt;
        if (d.age >= d.lifetime) d.alive = false;
      }
    }
    _drops.removeWhere((d) => !d.alive);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    for (final d in _drops) {
      if (!d.alive) continue;
      final alpha = ((1 - d.age / d.lifetime) * 200).toInt();
      paint.color = d.color.withAlpha(alpha);
      canvas.drawCircle(Offset(d.position.x, d.position.y), d.size, paint);
    }
  }
}

class LiquidDrop {
  Vector2 position;
  Vector2 velocity;
  double age = 0;
  double lifetime;
  Color color;
  double size;
  bool alive = true;

  LiquidDrop({
    required this.position,
    required this.velocity,
    required this.lifetime,
    required this.color,
    this.size = 4,
  });
}
