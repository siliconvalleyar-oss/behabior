import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class GlassEffectComponent extends PositionComponent {
  final List<GlassShard> _shards = [];

  void shatter({required Vector2 position, int count = 6}) {
    final random = Random();
    for (int i = 0; i < count; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 60 + random.nextDouble() * 100;
      _shards.add(GlassShard(
        position: position.clone(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        rotation: random.nextDouble() * 2 * pi,
        rotSpeed: (random.nextDouble() - 0.5) * 4,
        lifetime: 0.5 + random.nextDouble() * 0.3,
        size: 4 + random.nextDouble() * 8,
        color: const Color(0xFFA29BFE),
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final s in _shards) {
      if (s.alive) {
        s.position.add(s.velocity * dt);
        s.rotation += s.rotSpeed * dt;
        s.age += dt;
        if (s.age >= s.lifetime) s.alive = false;
      }
    }
    _shards.removeWhere((s) => !s.alive);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    for (final s in _shards) {
      if (!s.alive) continue;
      final alpha = ((1 - s.age / s.lifetime) * 200).toInt();
      paint.color = s.color.withAlpha(alpha);
      canvas.save();
      canvas.translate(s.position.x, s.position.y);
      canvas.rotate(s.rotation);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: s.size, height: s.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }
}

class GlassShard {
  Vector2 position;
  Vector2 velocity;
  double rotation;
  double rotSpeed;
  double age = 0;
  double lifetime;
  double size;
  Color color;
  bool alive = true;

  GlassShard({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotSpeed,
    required this.lifetime,
    required this.size,
    required this.color,
  });
}
