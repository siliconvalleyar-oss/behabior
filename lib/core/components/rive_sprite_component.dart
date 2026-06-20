import 'dart:ui';
import 'package:flame/components.dart';

class RiveSpriteComponent extends PositionComponent {
  String assetName;
  bool isLoaded = false;

  RiveSpriteComponent({
    required this.assetName,
    Vector2? size,
    Vector2? position,
  }) : super(size: size ?? Vector2.all(32), position: position ?? Vector2.zero());

  bool hasRiveFile = true;
  Color fallbackColor = const Color(0xFF6C5CE7);

  void triggerInput(String inputName) {}

  void setNumericInput(String inputName, double value) {}

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!hasRiveFile || !isLoaded) {
      final paint = Paint()
        ..color = fallbackColor
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
        paint,
      );
    }
  }
}
