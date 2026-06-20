import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

class Ground extends PositionComponent {
  Sprite? _sprite;
  double _scrollOffset = 0;

  Ground(Sprite? sprite) : super(size: Vector2(GameConfig.worldWidth, 40)) {
    _sprite = sprite;
  }

  @override
  Future<void> onLoad() async {
    if (_sprite == null) {
      try {
        _sprite = await Sprite.load('images/dino/piso.png');
      } catch (_) {}
    }
    y = GameConfig.groundY;
  }

  void scroll(double speed, double dt) {
    _scrollOffset = (_scrollOffset + speed * dt * 60) % 240;
  }

  @override
  void render(Canvas canvas) {
    if (_sprite != null) {
      for (double x = -_scrollOffset; x < size.x; x += 240) {
        _sprite!.render(canvas, position: Vector2(x, 0), size: Vector2(240, 40));
      }
    } else {
      final paint = Paint()..color = const Color(0xFF535353);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 3), paint);
    }
  }
}
