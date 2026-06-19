import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:vector_math/vector_math.dart' hide Colors;

class LiquidParticle {
  Vector2 position;
  Vector2 velocity;
  double radius;
  double targetRadius;
  Color color;
  double alpha;

  LiquidParticle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.targetRadius,
    required this.color,
    this.alpha = 0.8,
  });
}

class LiquidEffectComponent extends Component {
  final List<LiquidParticle> _particles = [];
  final Random _random = Random();
  bool _isActive = false;

  // Physics parameters
  double viscosity = 0.98;
  double surfaceTension = 0.1;
  double gravity = 100.0;

  void spawnSplash(Vector2 position, {Color color = Colors.blue, int count = 15}) {
    _isActive = true;
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 150 + 50;
      _particles.add(LiquidParticle(
        position: position.clone(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        radius: _random.nextDouble() * 6 + 2,
        targetRadius: _random.nextDouble() * 3 + 1,
        color: color,
        alpha: 0.8,
      ));
    }
  }

  void spawnPool(Vector2 position, {Color color = Colors.blue, double radius = 30.0}) {
    _isActive = true;
    for (int i = 0; i < 30; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final dist = _random.nextDouble() * radius;
      _particles.add(LiquidParticle(
        position: position + Vector2(cos(angle), sin(angle)) * dist,
        velocity: Vector2.zero(),
        radius: _random.nextDouble() * 4 + 2,
        targetRadius: _random.nextDouble() * 2 + 1,
        color: color.withOpacity(0.5),
        alpha: 0.5,
      ));
    }
  }

  @override
  void update(double dt) {
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];

      // Physics
      p.velocity *= viscosity;
      p.velocity.y += gravity * dt;
      p.position += p.velocity * dt;

      // Surface tension (pull toward center of mass)
      if (_particles.length > 1) {
        Vector2 center = Vector2.zero();
        for (final other in _particles) {
          center += other.position;
        }
        center /= _particles.length.toDouble();
        final toCenter = center - p.position;
        p.velocity += toCenter * surfaceTension * dt;
      }

      // Shrink and fade
      p.radius += (p.targetRadius - p.radius) * 2 * dt;
      p.alpha -= dt * 0.5;

      if (p.alpha <= 0 || p.radius <= 0.5) {
        _particles.removeAt(i);
      }
    }

    if (_particles.isEmpty) {
      _isActive = false;
    }
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(p.alpha.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
        Offset(p.position.x, p.position.y),
        p.radius,
        paint,
      );
    }
  }

  bool get isActive => _isActive;
  void clear() => _particles.clear();
}
