import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class ParticleComponent extends PositionComponent {
  final List<ParticleInstance> particles = [];
  final Random _random = Random();
  bool _active = false;

  ParticleComponent();

  void emit({
    required Vector2 position,
    int count = 10,
    Color color = const Color(0xFF6C5CE7),
    double speed = 100,
    double lifetime = 0.5,
  }) {
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final spd = speed * (0.5 + _random.nextDouble());
      particles.add(ParticleInstance(
        position: position.clone(),
        velocity: Vector2(cos(angle), sin(angle)) * spd,
        lifetime: lifetime * (0.5 + _random.nextDouble()),
        color: color,
        size: 2 + _random.nextDouble() * 4,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in particles) {
      if (p.alive) {
        p.position.add(p.velocity * dt);
        p.age += dt;
        if (p.age >= p.lifetime) p.alive = false;
      }
    }
    particles.removeWhere((p) => !p.alive);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    for (final p in particles) {
      if (!p.alive) continue;
      final alpha = ((1 - p.age / p.lifetime) * 255).toInt();
      paint.color = p.color.withAlpha(alpha);
      canvas.drawCircle(Offset(p.position.x, p.position.y), p.size, paint);
    }
  }
}

class ParticleInstance {
  Vector2 position;
  Vector2 velocity;
  double age = 0;
  double lifetime;
  Color color;
  double size;
  bool alive = true;

  ParticleInstance({
    required this.position,
    required this.velocity,
    required this.lifetime,
    required this.color,
    this.size = 3,
  });
}
