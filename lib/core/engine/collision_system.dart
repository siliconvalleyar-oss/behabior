import 'package:flame/components.dart';
import 'package:behabior/core/entities/player.dart';
import 'package:behabior/core/entities/enemy.dart';
import 'package:behabior/core/entities/projectile.dart';

enum CollisionLayer {
  player,
  enemy,
  projectile,
  obstacle,
  pickup,
  boss,
}

class CollisionInfo {
  final HasHitboxCollision a;
  final HasHitboxCollision b;
  final CollisionLayer layerA;
  final CollisionLayer layerB;
  final Vector2 contactPoint;
  final Vector2 normal;

  CollisionInfo({
    required this.a,
    required this.b,
    required this.layerA,
    required this.layerB,
    required this.contactPoint,
    required this.normal,
  });
}

mixin HasHitboxCollision {
  Vector2 get position;
  double get hitboxRadius;
  CollisionLayer get collisionLayer;
  bool get isActive;

  void onCollision(CollisionInfo info);

  bool overlaps(HasHitboxCollision other) {
    final dist = (position - other.position).length;
    return dist < hitboxRadius + other.hitboxRadius;
  }

  CollisionInfo? getCollisionInfo(HasHitboxCollision other) {
    if (!overlaps(other)) return null;
    final normal = (other.position - position)..normalize();
    return CollisionInfo(
      a: this,
      b: other,
      layerA: collisionLayer,
      layerB: other.collisionLayer,
      contactPoint: (position + other.position) / 2,
      normal: normal,
    );
  }
}

class CollisionSystem {
  final List<HasHitboxCollision> _collidables = [];

  void add(HasHitboxCollision collidable) {
    _collidables.add(collidable);
  }

  void remove(HasHitboxCollision collidable) {
    _collidables.remove(collidable);
  }

  void clear() {
    _collidables.clear();
  }

  void update(double dt) {
    for (int i = 0; i < _collidables.length; i++) {
      final a = _collidables[i];
      if (!a.isActive) continue;
      for (int j = i + 1; j < _collidables.length; j++) {
        final b = _collidables[j];
        if (!b.isActive) continue;
        final info = a.getCollisionInfo(b);
        if (info != null) {
          a.onCollision(info);
          b.onCollision(CollisionInfo(
            a: b,
            b: a,
            layerA: b.collisionLayer,
            layerB: a.collisionLayer,
            contactPoint: info.contactPoint,
            normal: -info.normal,
          ));
        }
      }
    }
  }
}
