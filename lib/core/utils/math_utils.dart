import 'dart:math';
import 'package:vector_math/vector_math_64.dart' show Vector2;

class MathUtils {
  static final Random _random = Random();

  static double randomBetween(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }

  static int randomIntBetween(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  static Vector2 randomDirection() {
    final angle = _random.nextDouble() * 2 * pi;
    return Vector2(cos(angle), sin(angle));
  }

  static Vector2 directionTo(Vector2 from, Vector2 to) {
    return (to - from)..normalize();
  }

  static double distanceBetween(Vector2 a, Vector2 b) {
    return (b - a).length;
  }

  static double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  static double clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }

  static bool chance(double probability) {
    return _random.nextDouble() < probability;
  }
}
