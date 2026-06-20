import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

class Ground extends PositionComponent {
  double _scrollOffset = 0;

  Ground() : super(size: Vector2(GameConfig.worldWidth, 30));

  @override
  Future<void> onLoad() async {
    position.y = GameConfig.groundY;
  }

  void scroll(double speed, double dt) {
    _scrollOffset = (_scrollOffset + speed * dt * 60) % 24;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF535353);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 2), paint);

    paint.color = const Color(0xFFCCCCCC);
    final dotSize = 4.0;
    final spacing = 24.0;
    for (double x = -_scrollOffset; x < size.x; x += spacing) {
      canvas.drawRect(Rect.fromLTWH(x, 6, dotSize, 2), paint);
      canvas.drawRect(Rect.fromLTWH(x + spacing / 2, 14, dotSize - 1, 2), paint);
      canvas.drawRect(Rect.fromLTWH(x + spacing * 0.75, 22, dotSize - 2, 2), paint);
    }
  }
}
