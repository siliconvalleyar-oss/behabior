import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

class Projectile extends PositionComponent {
  Vector2 _direction = Vector2.zero();
  double _speed = GameConfig.projectileSpeed;
  double _damage = 10;
  double _lifetime = GameConfig.projectileLifetime;
  double _age = 0;
  bool active = false;
  double radius = GameConfig.projectileSize / 2;

  Projectile()
      : super(size: Vector2.all(GameConfig.projectileSize));

  void init({
    required Vector2 position,
    required Vector2 direction,
    double damage = 10,
  }) {
    this.position.setFrom(position);
    _direction.setFrom(direction);
    _damage = damage;
    _age = 0;
    active = true;
  }

  double get damage => _damage;
  bool get isExpired => _age >= _lifetime;

  void move(double dt) {
    if (!active) return;
    _age += dt;
    position.add(_direction * _speed * dt);
  }

  @override
  void render(Canvas canvas) {
    if (!active) return;
    final paint = Paint()..color = const Color(0xFF6C5CE7);
    canvas.drawCircle(Offset.zero, size.x / 2, paint);

    final glow = Paint()
      ..color = const Color(0x446C5CE7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset.zero, size.x / 2 + 3, glow);
  }
}
