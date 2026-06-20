import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class Cloud extends PositionComponent {
  final double _speed;
  final double _cloudWidth;
  final double _cloudHeight;

  Cloud({required double worldWidth, required double speed})
      : _speed = speed * 0.3,
        _cloudWidth = 40 + Random().nextDouble() * 40,
        _cloudHeight = 14 + Random().nextDouble() * 10 {
    final rand = Random();
    position.setValues(
      worldWidth + rand.nextDouble() * 200,
      20 + rand.nextDouble() * 60,
    );
    size.setValues(_cloudWidth, _cloudHeight);
  }

  void move(double dt) {
    position.x -= _speed * dt * 60;
  }

  bool get isOffScreen => position.x < -100;

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC).withAlpha(80);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, _cloudWidth, _cloudHeight),
        Radius.circular(_cloudHeight / 2),
      ),
      paint,
    );
    canvas.drawCircle(
      Offset(_cloudWidth * 0.3, _cloudHeight * 0.5),
      _cloudHeight * 0.6,
      paint,
    );
    canvas.drawCircle(
      Offset(_cloudWidth * 0.7, _cloudHeight * 0.5),
      _cloudHeight * 0.5,
      paint,
    );
  }
}
