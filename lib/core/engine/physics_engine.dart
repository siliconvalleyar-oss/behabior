import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

/// Manages spatial proximity and simple collision detection
/// for the top-down 2D game (no Forge2D gravity needed).
class PhysicsEngine {
  final List<HasHitbox> _bodies = [];

  void addBody(HasHitbody body) {
    _bodies.add(body);
  }

  void removeBody(HasHitbody body) {
    _bodies.remove(body);
  }

  void clear() {
    _bodies.clear();
  }

  List<HasHitbody> checkCollisions(HasHitbody body) {
    final hits = <HasHitbody>[];
    for (final other in _bodies) {
      if (other == body) continue;
      if (body.hitbox.overlaps(other.hitbox)) {
        hits.add(other);
      }
    }
    return hits;
  }

  List<HasHitbody> checkCollisionsInRadius(Vector2 position, double radius) {
    return _bodies.where((body) {
      final dist = (body.position - position).length;
      return dist < radius + body.hitboxRadius;
    }).toList();
  }

  HasHitbody? raycast(Vector2 origin, Vector2 direction, double maxDistance) {
    HasHitbody? closest;
    double closestDist = maxDistance;
    for (final body in _bodies) {
      final dist = _rayIntersectRect(
        origin,
        direction,
        body.hitbox,
      );
      if (dist >= 0 && dist < closestDist) {
        closestDist = dist;
        closest = body;
      }
    }
    return closest;
  }

  double _rayIntersectRect(Vector2 origin, Vector2 dir, Rectangle hitbox) {
    final invDir = Vector2(1.0 / dir.x, 1.0 / dir.y);
    final t1 = (hitbox.left - origin.x) * invDir.x;
    final t2 = (hitbox.right - origin.x) * invDir.x;
    final t3 = (hitbox.top - origin.y) * invDir.y;
    final t4 = (hitbox.bottom - origin.y) * invDir.y;
    final tMin = [t1, t2, t3, t4].reduce((a, b) => a < b ? a : b);
    final tMax = [t1, t2, t3, t4].reduce((a, b) => a > b ? a : b);
    if (tMax < 0) return -1;
    if (tMin < 0) return tMax;
    return tMin;
  }
}

mixin HasHitbody {
  Vector2 get position;
  double get hitboxRadius;
  Rectangle<double> get hitbox => Rectangle.fromCircle(
        Center: position, radius: hitboxRadius);
}
