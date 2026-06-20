import 'dart:math' show atan2, min, pi;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/entities/base_entity.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/engine/collision_system.dart';

class Projectile extends BaseEntity {
  final Vector2 direction;
  final double projectileSpeed;
  double lifetime = 2.0;
  double _age = 0.0;
  bool hasHit = false;

  void Function(Projectile projectile)? onHit;
  void Function(Projectile projectile)? onExpire;

  late final Sprite _sprite;

  Projectile({
    Vector2? position,
    required this.direction,
    this.projectileSpeed = GameConfig.projectileSpeed,
    double? damage,
    EntityTeam? team,
    double? size,
  }) : super(
          position: position ?? Vector2.zero(),
          hitboxRadius: (size ?? GameConfig.projectileSize) / 2,
          team: team ?? EntityTeam.player,
          health: 1.0,
          maxHealth: 1.0,
          speed: 0.0,
          damage: damage ?? 10.0,
          size: Vector2(size ?? GameConfig.projectileSize, size ?? GameConfig.projectileSize),
        );

  String get _spritePath => '';

  @override
  Future<void> onLoad() async {
    final path = team == EntityTeam.player
        ? 'assets/images/naves/disparo_de_nave_00.png'
        : 'assets/images/naves/disparo_de_nave_01.png';
    try {
      _sprite = await Sprite.load(path);
    } catch (e) {
      try {
        final fallback = team == EntityTeam.player
            ? 'images/naves/disparo_de_nave_00.png'
            : 'images/naves/disparo_de_nave_01.png';
        _sprite = await Sprite.load(fallback);
      } catch (_) {
        _sprite = Sprite(await _createPlaceholderImage());
      }
    }
  }

  Future<Image> _createPlaceholderImage() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = team == EntityTeam.player ? Color(0xFF00FF00) : Color(0xFFFF0000);
    canvas.drawCircle(const Offset(4, 4), 4, paint);
    final picture = recorder.endRecording();
    final img = await picture.toImage(8, 8);
    return img;
  }

  @override
  void updatePhysics(double dt) {
    if (hasHit || isDead) return;

    _age += dt;
    position += direction * projectileSpeed * dt;

    if (_age >= lifetime) {
      hasHit = true;
      onExpire?.call(this);
      removeFromParent();
      return;
    }

    if (position.x < -50 || position.x > GameConfig.worldWidth + 50 ||
        position.y < -50 || position.y > GameConfig.worldHeight + 50) {
      hasHit = true;
      removeFromParent();
    }

    angle = atan2(direction.y, direction.x) + pi / 2;
  }

  @override
  void onCollision(CollisionInfo info) {
    if (hasHit) return;

    if ((team == EntityTeam.player && info.layerB == CollisionLayer.enemy) ||
        (team == EntityTeam.player && info.layerB == CollisionLayer.boss) ||
        (team == EntityTeam.enemy && info.layerB == CollisionLayer.player)) {
      hasHit = true;
      onHit?.call(this);
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final spriteSize = _sprite.srcSize;
    final scale = min(size.x / spriteSize.x, size.y / spriteSize.y);
    final scaled = spriteSize * scale;
    final offset = (size - scaled) / 2;

    _sprite.render(canvas, position: offset, size: scaled);
  }
}
