import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class FluidSquadEffectComponent extends PositionComponent {
  final List<FluidBlob> _blobs = [];
  final Random _random = Random();

  void addBlob({required Vector2 position, Color? color}) {
    _blobs.add(FluidBlob(
      position: position.clone(),
      velocity: Vector2(
        (_random.nextDouble() - 0.5) * 60,
        (_random.nextDouble() - 0.5) * 60,
      ),
      color: color ?? const Color(0xFF6C5CE7),
      size: 6 + _random.nextDouble() * 10,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final b in _blobs) {
      if (b.alive) {
        b.position.add(b.velocity * dt);
        b.age += dt;
        if (b.age >= b.lifetime) {
          b.alive = false;
        }
      }
    }
    _blobs.removeWhere((b) => !b.alive);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    for (final b in _blobs) {
      if (!b.alive) continue;
      final alpha = ((1 - b.age / b.lifetime) * 180).toInt();
      paint.color = b.color.withAlpha(alpha);
      canvas.drawCircle(Offset(b.position.x, b.position.y), b.size, paint);
    }
  }
}

class FluidBlob {
  Vector2 position;
  Vector2 velocity;
  double age = 0;
  double lifetime = 0.8;
  Color color;
  double size;
  bool alive = true;

  FluidBlob({
    required this.position,
    required this.velocity,
    required this.color,
    this.size = 8,
  });
}
