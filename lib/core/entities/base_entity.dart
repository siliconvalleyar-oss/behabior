import 'dart:ui';
import 'package:flame/components.dart';

enum EntityState { idle, moving, attacking, damaged, dying, dead }

class BaseEntity extends PositionComponent {
  double currentHealth;
  double maxHealth;
  double speed;
  double contactDamage;
  bool active = true;
  EntityState _state = EntityState.idle;

  BaseEntity({
    super.position,
    Vector2? size,
    this.currentHealth = 100,
    this.maxHealth = 100,
    this.speed = 100,
    this.contactDamage = 5,
  }) : super(size: size ?? Vector2(32, 32));

  EntityState get state => _state;
  double get radius => size.x / 2;

  set state(EntityState newState) {
    if (_state != newState) {
      _state = newState;
      onStateChanged(newState);
    }
  }

  void onStateChanged(EntityState newState) {}

  void takeDamage(double amount) {
    currentHealth -= amount;
    state = EntityState.damaged;
    if (currentHealth <= 0) {
      currentHealth = 0;
      state = EntityState.dying;
      active = false;
      onDeath();
    }
  }

  void onDeath() {}
  void heal(double amount) {
    currentHealth = (currentHealth + amount).clamp(0, maxHealth);
  }

  void reset() {
    currentHealth = maxHealth;
    active = true;
    state = EntityState.idle;
  }

  void updatePhysics(double dt) {}

  void updateHealthBar() {}

  @override
  void update(double dt) {
    super.update(dt);
    if (state == EntityState.dying || state == EntityState.dead) {
      if (!active) {
        removeFromParent();
      }
    }
  }
}
