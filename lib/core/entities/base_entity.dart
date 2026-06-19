import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

enum EntityState { idle, moving, attacking, damaged, dying, dead }

enum EntityTeam { player, enemy, neutral }

class BaseEntity extends PositionComponent with HasHitboxCollision {
  @override
  Vector2 position;
  @override
  double hitboxRadius;
  EntityTeam team;
  EntityState _state = EntityState.idle;
  double health;
  double maxHealth;
  double speed;
  double damage;
  bool _isActive = true;

  BaseEntity({
    Vector2? position,
    this.hitboxRadius = 16.0,
    this.team = EntityTeam.neutral,
    this.health = 100.0,
    this.maxHealth = 100.0,
    this.speed = 100.0,
    this.damage = 10.0,
    super.size,
  }) : position = position ?? Vector2.zero();

  EntityState get state => _state;
  set state(EntityState newState) {
    if (_state != newState) {
      _state = newState;
      onStateChanged(newState);
    }
  }

  void onStateChanged(EntityState state) {}

  @override
  bool get isActive => _isActive;

  void takeDamage(double amount, {Vector2? from}) {
    health -= amount;
    state = EntityState.damaged;
    if (health <= 0) {
      health = 0;
      die();
    }
  }

  void die() {
    _isActive = false;
    state = EntityState.dead;
  }

  void heal(double amount) {
    health = (health + amount).clamp(0.0, maxHealth);
  }

  double get healthPercent => health / maxHealth;

  bool get isDead => health <= 0 || !_isActive;

  void moveToward(Vector2 target, double dt) {
    final dir = (target - position)..normalize();
    position += dir * speed * dt;
    if (dir.length > 0.1) {
      state = EntityState.moving;
    } else {
      state = EntityState.idle;
    }
  }

  Vector2 directionTo(Vector2 target) {
    return (target - position)..normalize();
  }

  double distanceTo(Vector2 target) {
    return (target - position).length;
  }

  @override
  CollisionLayer get collisionLayer {
    switch (team) {
      case EntityTeam.player:
        return CollisionLayer.player;
      case EntityTeam.enemy:
        return CollisionLayer.enemy;
      case EntityTeam.neutral:
        return CollisionLayer.obstacle;
    }
  }

  @override
  void onCollision(CollisionInfo info) {
    // Override in subclasses
  }

  void updatePhysics(double dt) {
    // Override in subclasses for physics behavior
  }
}
