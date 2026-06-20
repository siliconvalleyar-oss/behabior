import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

enum ObstacleType { cactusSingle, cactusDouble, pterodactyl }

class Obstacle extends PositionComponent {
  final ObstacleType type;
  bool passed = false;

  Sprite? _sprite;
  Sprite? _spriteDouble;
  Sprite? _birdSprite;

  Obstacle({required this.type});

  factory Obstacle.random(double speed) {
    final rand = Random();
    final types = [
      ObstacleType.cactusSingle,
      ObstacleType.cactusSingle,
      ObstacleType.cactusDouble,
      if (speed > 8) ObstacleType.pterodactyl,
      if (speed > 10) ObstacleType.pterodactyl,
    ];
    final type = types[rand.nextInt(types.length)];
    return Obstacle(type: type);
  }

  @override
  Future<void> onLoad() async {
    try {
      _sprite = await Sprite.load('images/dino/un_cactus.png');
      _spriteDouble = await Sprite.load('images/dino/dos_cactus.png');
      _birdSprite = await Sprite.load('images/dino/ave.png');
    } catch (_) {}

    switch (type) {
      case ObstacleType.cactusSingle:
        size.setValues(40, 70);
        break;
      case ObstacleType.cactusDouble:
        size.setValues(70, 70);
        break;
      case ObstacleType.pterodactyl:
        size.setValues(60, 40);
        break;
    }
    y = GameConfig.groundY - height;
    if (type == ObstacleType.pterodactyl) {
      y -= 30 + Random().nextDouble() * 20;
    }
    x = GameConfig.worldWidth + 50;
  }

  void move(double speed, double dt) {
    x -= speed * dt * 60;
  }

  bool get isOffScreen => x < -100;

  @override
  void render(Canvas canvas) {
    final paint = Paint();
    switch (type) {
      case ObstacleType.cactusSingle:
        if (_sprite != null) {
          _sprite!.render(canvas, size: size);
        } else {
          paint.color = const Color(0xFF4CAF50);
          canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
        }
      case ObstacleType.cactusDouble:
        if (_spriteDouble != null) {
          _spriteDouble!.render(canvas, size: size);
        } else {
          paint.color = const Color(0xFF388E3C);
          canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
        }
      case ObstacleType.pterodactyl:
        if (_birdSprite != null) {
          _birdSprite!.render(canvas, size: size);
        } else {
          paint.color = const Color(0xFF757575);
          canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
        }
    }
  }
}
