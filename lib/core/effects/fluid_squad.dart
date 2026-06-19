import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

class FluidBlob {
  Vector2 position;
  Vector2 velocity;
  double radius;
  double squash;
  double stretch;
  Color color;
  Color innerColor;
  double alpha;

  FluidBlob({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    this.innerColor = Colors.white,
    this.squash = 0.0,
    this.stretch = 0.0,
    this.alpha = 0.7,
  });
}

class FluidSquadEffectComponent extends Component {
  final List<FluidBlob> _blobs = [];
  final Random _random = Random();
  bool _isActive = false;

  // Fluid simulation parameters
  double blobMergeDistance = 30.0;
  double surfaceTension = 0.05;
  double viscosity = 0.97;
  double gravity = 50.0;

  void spawnBlob(Vector2 position, {Color color = const Color(0x8866BBFF), double radius = 15.0}) {
    _isActive = true;
    _blobs.add(FluidBlob(
      position: position.clone(),
      velocity: Vector2(
        _random.nextDouble() * 50 - 25,
        _random.nextDouble() * 50 - 25,
      ),
      radius: radius,
      color: color,
      innerColor: color.withOpacity(0.6),
    ));
  }

  void spawnFluidPool(Vector2 position, {Color color = const Color(0x8866BBFF), int count = 8}) {
    _isActive = true;
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final dist = _random.nextDouble() * 40;
      _blobs.add(FluidBlob(
        position: position + Vector2(cos(angle), sin(angle)) * dist,
        velocity: Vector2.zero(),
        radius: _random.nextDouble() * 10 + 5,
        color: color,
      ));
    }
  }

  void spawnLiquidTrail(Vector2 position, {Color color = const Color(0x8844FF88)}) {
    _blobs.add(FluidBlob(
      position: position.clone(),
      velocity: Vector2.zero(),
      radius: _random.nextDouble() * 5 + 2,
      color: color,
      alpha: 0.5,
    ));
    if (_blobs.length > 50) {
      _blobs.removeAt(0);
    }
  }

  @override
  void update(double dt) {
    // Fluid dynamics simulation
    for (int i = 0; i < _blobs.length; i++) {
      final a = _blobs[i];
      a.velocity *= viscosity;
      a.velocity.y += gravity * dt;
      a.position += a.velocity * dt;

      // Blob-blob interactions (merge + surface tension)
      for (int j = i + 1; j < _blobs.length; j++) {
        final b = _blobs[j];
        final diff = b.position - a.position;
        final dist = diff.length;

        if (dist < blobMergeDistance) {
          // Surface tension (pull together)
          final force = (blobMergeDistance - dist) / blobMergeDistance * surfaceTension;
          final dir = diff / (dist + 0.001);
          a.velocity += dir * force;
          b.velocity -= dir * force;

          // Merge if very close
          if (dist < (a.radius + b.radius) * 0.5) {
            final totalMass = a.radius * a.radius + b.radius * b.radius;
            a.position = (a.position * a.radius + b.position * b.radius) /
                (a.radius + b.radius);
            a.radius = sqrt(totalMass);
            a.velocity = (a.velocity + b.velocity) / 2;
            _blobs.removeAt(j);
            j--;
            continue;
          }
        }
      }

      // Deformation
      a.squash = a.velocity.y * 0.01;
      a.stretch = a.velocity.x * 0.01;

      // Fade/Sink
      a.alpha -= dt * 0.1;
      if (a.radius > 2) a.radius -= dt * 0.5;

      if (a.alpha <= 0 || a.radius <= 1) {
        _blobs.removeAt(i);
        i--;
      }
    }

    _isActive = _blobs.isNotEmpty;
  }

  @override
  void render(Canvas canvas) {
    for (final b in _blobs) {
      canvas.save();
      canvas.translate(b.position.x, b.position.y);

      // Squash and stretch
      canvas.scale(1 + b.stretch, 1 + b.squash);

      // Outer glow
      final outerPaint = Paint()
        ..color = b.color.withOpacity(b.alpha * 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset.zero, b.radius * 1.3, outerPaint);

      // Main blob
      final mainPaint = Paint()
        ..color = b.color.withOpacity(b.alpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset.zero, b.radius, mainPaint);

      // Inner highlight
      final innerPaint = Paint()
        ..color = b.innerColor.withOpacity(b.alpha * 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(-b.radius * 0.2, -b.radius * 0.2),
        b.radius * 0.5,
        innerPaint,
      );

      canvas.restore();
    }
  }

  bool get isActive => _isActive;
  void clear() => _blobs.clear();
}
