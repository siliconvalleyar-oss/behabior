import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class Cloud extends PositionComponent {
  Sprite? _sprite;
  final double _speed;

  Cloud({required double speed})
      : _speed = speed * 0.2,
        super(size: Vector2(70, 40)) {
    final rand = Random();
    x = 900 + rand.nextDouble() * 200;
    y = 20 + rand.nextDouble() * 60;
  }

  @override
  Future<void> onLoad() async {
    try {
      _sprite = await Sprite.load('images/dino/nube.png');
    } catch (_) {}
  }

  void move(double speed, double dt) {
    x -= _speed * dt * 60;
  }

  bool get isOffScreen => x < -100;
}
