import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

class GlassShard {
  Vector2 position;
  Vector2 velocity;
  double rotation;
  double rotationSpeed;
  double size;
  Color color;
  double alpha;
  final List<Offset> shape;

  GlassShard({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
    this.alpha = 0.9,
  }) : shape = _generateShape(size);

  static List<Offset> _generateShape(double size) {
    final r = Random();
    final vertices = 3 + r.nextInt(3); // 3-5 vertices
    return List.generate(vertices, (i) {
      final angle = (2 * pi * i / vertices) + r.nextDouble() * 0.5;
      final dist = size * (0.5 + r.nextDouble() * 0.5);
      return Offset(cos(angle) * dist, sin(angle) * dist);
    });
  }
}

class GlassEffectComponent extends Component {
  final List<GlassShard> _shards = [];
  final Random _random = Random();

  void breakGlass(Vector2 position, {Color color = const Color(0x88B0E0FF), int shardCount = 12}) {
    for (int i = 0; i < shardCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 200 + 50;
      _shards.add(GlassShard(
        position: position.clone(),
        velocity: Vector2(cos(angle), sin(angle)) * speed,
        size: _random.nextDouble() * 8 + 3,
        color: color,
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
      ));
    }
  }

  void createGlassWall(Vector2 position, Vector2 size) {
    // A static glass obstacle representation
    // Shards created on break
  }

  @override
  void update(double dt) {
    for (int i = _shards.length - 1; i >= 0; i--) {
      final s = _shards[i];
      s.position += s.velocity * dt;
      s.velocity *= 0.95;
      s.velocity.y += 200 * dt; // gravity
      s.rotation += s.rotationSpeed * dt;
      s.alpha -= dt * 0.8;
      s.rotationSpeed *= 0.98;

      if (s.alpha <= 0) {
        _shards.removeAt(i);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (final s in _shards) {
      canvas.save();
      canvas.translate(s.position.x, s.position.y);
      canvas.rotate(s.rotation);

      final paint = Paint()
        ..color = s.color.withOpacity(s.alpha.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

      final path = Path()..addPolygon(s.shape, true);
      canvas.drawPath(path, paint);

      // Edge highlight
      final edgePaint = Paint()
        ..color = Colors.white.withOpacity(s.alpha * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      canvas.drawPath(path, edgePaint);

      canvas.restore();
    }
  }

  void clear() => _shards.clear();
  int get shardCount => _shards.length;
}
