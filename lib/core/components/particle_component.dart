import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;
import 'package:behabior/core/utils/math_utils.dart';

class Particle {
  Vector2 position;
  Vector2 velocity;
  double life;
  double maxLife;
  double size;
  Color color;
  double alpha;

  Particle({
    required this.position,
    required this.velocity,
    required this.maxLife,
    this.size = 4.0,
    this.color = Colors.white,
    this.alpha = 1.0,
  }) : life = maxLife;
}

enum ParticleEmitterType {
  burst,
  stream,
  fountain,
  explosion,
}

class ParticleComponent extends Component {
  final List<Particle> _particles = [];
  final Random _random = Random();
  bool _emitting = false;
  double _emitTimer = 0.0;
  ParticleEmitterType _emitterType = ParticleEmitterType.burst;

  // Emitter config
  double emitRate = 20.0;
  double particleLifetime = 1.0;
  double particleSpeed = 100.0;
  double particleSize = 4.0;
  Color particleColor = Colors.white;
  Color? particleColorEnd;
  double spawnRadius = 10.0;
  int burstCount = 30;

  void emit({
    required Vector2 position,
    ParticleEmitterType type = ParticleEmitterType.burst,
    int? count,
    Color? color,
    double? speed,
    double? lifetime,
    double? size,
    double? radius,
  }) {
    _emitterType = type;
    final emitPos = position;
    final emitCount = count ?? burstCount;
    final emitColor = color ?? particleColor;
    final emitSpeed = speed ?? particleSpeed;
    final emitLifetime = lifetime ?? particleLifetime;
    final emitSize = size ?? particleSize;
    final emitRadius = radius ?? spawnRadius;

    switch (type) {
      case ParticleEmitterType.burst:
      case ParticleEmitterType.explosion:
        for (int i = 0; i < emitCount; i++) {
          final angle = _random.nextDouble() * 2 * pi;
          final spd = MathUtils.randomBetween(emitSpeed * 0.5, emitSpeed);
          _particles.add(Particle(
            position: emitPos + Vector2(
              MathUtils.randomBetween(-emitRadius, emitRadius),
              MathUtils.randomBetween(-emitRadius, emitRadius),
            ),
            velocity: Vector2(cos(angle), sin(angle)) * spd,
            maxLife: MathUtils.randomBetween(emitLifetime * 0.5, emitLifetime),
            size: MathUtils.randomBetween(emitSize * 0.5, emitSize),
            color: emitColor,
          ));
        }
        break;
      case ParticleEmitterType.stream:
        _emitting = true;
        emitRate = emitCount.toDouble();
        break;
      case ParticleEmitterType.fountain:
        for (int i = 0; i < emitCount; i++) {
          final vx = MathUtils.randomBetween(-emitSpeed, emitSpeed);
          final vy = MathUtils.randomBetween(-emitSpeed * 2, -emitSpeed * 0.5);
          _particles.add(Particle(
            position: emitPos + Vector2(
              MathUtils.randomBetween(-emitRadius, emitRadius), 0),
            velocity: Vector2(vx, vy),
            maxLife: MathUtils.randomBetween(emitLifetime * 0.5, emitLifetime),
            size: MathUtils.randomBetween(emitSize * 0.5, emitSize),
            color: emitColor,
          ));
        }
        break;
    }
  }

  void emitExplosion(Vector2 position, {Color? color, double? radius}) {
    emit(
      position: position,
      type: ParticleEmitterType.explosion,
      count: 40,
      color: color ?? Colors.orange,
      speed: 200.0,
      lifetime: 0.8,
      size: 6.0,
      radius: radius ?? 15.0,
    );
  }

  void emitBlood(Vector2 position) {
    emit(
      position: position,
      type: ParticleEmitterType.burst,
      count: 15,
      color: Colors.red,
      speed: 80.0,
      lifetime: 0.5,
      size: 3.0,
    );
  }

  void emitGlassShard(Vector2 position) {
    emit(
      position: position,
      type: ParticleEmitterType.explosion,
      count: 20,
      color: Colors.lightBlue.withOpacity(0.7),
      speed: 150.0,
      lifetime: 1.0,
      size: 5.0,
      radius: 20.0,
    );
  }

  @override
  void update(double dt) {
    // Continuous emission
    if (_emitting) {
      _emitTimer += dt;
      final interval = 1.0 / emitRate;
      while (_emitTimer >= interval) {
        _emitTimer -= interval;
        final angle = _random.nextDouble() * 2 * pi;
        _particles.add(Particle(
          position: Vector2.zero(),
          velocity: Vector2(cos(angle), sin(angle)) * particleSpeed,
          maxLife: particleLifetime,
          size: particleSize,
          color: particleColor,
        ));
      }
    }

    // Update existing particles
    for (int i = _particles.length - 1; i >= 0; i--) {
      final p = _particles[i];
      p.life -= dt;
      p.position += p.velocity * dt;
      p.velocity *= 0.95; // drag
      p.alpha = (p.life / p.maxLife).clamp(0.0, 1.0);

      if (p.life <= 0) {
        _particles.removeAt(i);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(p.alpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(p.position.x, p.position.y),
        p.size * p.alpha,
        paint,
      );
    }
  }

  void stop() {
    _emitting = false;
  }

  void clear() {
    _particles.clear();
    _emitting = false;
  }

  int get particleCount => _particles.length;
}
