import 'dart:ui';
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

extension Vector2X on Vector2 {
  double get angle => atan2(y, x);

  Vector2 lerp(Vector2 target, double t) {
    return Vector2(
      x + (target.x - x) * t,
      y + (target.y - y) * t,
    );
  }

  Vector2 clamped(double maxMagnitude) {
    if (length > maxMagnitude) {
      return normalized * maxMagnitude;
    }
    return this;
  }
}

extension RectX on Rect {
  Vector2 get centerVector2 => Vector2(center.dx, center.dy);
}

extension ColorX on Color {
  Color withAlphaInt(int alpha) {
    return Color.fromARGB(alpha.clamp(0, 255), red, green, blue);
  }
}
