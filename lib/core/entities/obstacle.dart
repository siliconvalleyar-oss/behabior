import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

enum ObstacleType { cactusSmall, cactusLarge, pterodactyl }

class Obstacle extends PositionComponent {
  final ObstacleType type;
  final bool isPterodactyl;
  bool passed = false;

  Obstacle({
    required this.type,
    bool? isPterodactyl,
  }) : isPterodactyl = isPterodactyl ?? (type == ObstacleType.pterodactyl),
       super();

  factory Obstacle.random(double speed) {
    final rand = Random();
    final types = [
      ObstacleType.cactusSmall,
      ObstacleType.cactusSmall,
      ObstacleType.cactusLarge,
      if (speed > 7) ObstacleType.pterodactyl,
    ];
    final type = types[rand.nextInt(types.length)];
    return Obstacle(type: type);
  }

  @override
  Future<void> onLoad() async {
    switch (type) {
      case ObstacleType.cactusSmall:
        size.setValues(20, 40);
        position.y = GameConfig.groundY - 40;
      case ObstacleType.cactusLarge:
        size.setValues(30, 60);
        position.y = GameConfig.groundY - 60;
      case ObstacleType.pterodactyl:
        size.setValues(40, 30);
        final rand = Random();
        position.y = rand.nextBool() ? GameConfig.pterodactylY : GameConfig.pterodactylLowY;
    }
    position.x = GameConfig.worldWidth + 50;
  }

  void move(double speed, double dt) {
    position.x -= speed * dt * 60;
  }

  bool get isOffScreen => position.x < -100;

  double get hitboxLeft => position.x + 2;
  double get hitboxTop => position.y + 2;
  double get hitboxRight => position.x + size.x - 2;
  double get hitboxBottom => position.y + size.y - 2;

  @override
  void render(Canvas canvas) {
    final paint = Paint();

    switch (type) {
      case ObstacleType.cactusSmall:
        paint.color = const Color(0xFF4CAF50);
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(2, 0, 16, 40), const Radius.circular(3)),
          paint,
        );
        paint.color = const Color(0xFF388E3C);
        canvas.drawRect(Rect.fromLTWH(2, 0, 16, 40), paint);
        paint.color = const Color(0xFF2E7D32);
        canvas.drawRect(Rect.fromLTWH(4, 5, 12, 2), paint);
        canvas.drawRect(Rect.fromLTWH(4, 15, 12, 2), paint);
        paint.color = const Color(0xFF4CAF50);
        canvas.drawRect(Rect.fromLTWH(0, 8, 6, 4), paint);
        canvas.drawRect(Rect.fromLTWH(14, 18, 6, 4), paint);

      case ObstacleType.cactusLarge:
        paint.color = const Color(0xFF388E3C);
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(2, 0, 26, 60), const Radius.circular(4)),
          paint,
        );
        paint.color = const Color(0xFF2E7D32);
        canvas.drawRect(Rect.fromLTWH(4, 8, 22, 2), paint);
        canvas.drawRect(Rect.fromLTWH(4, 22, 22, 2), paint);
        canvas.drawRect(Rect.fromLTWH(4, 36, 22, 2), paint);
        paint.color = const Color(0xFF4CAF50);
        canvas.drawRect(Rect.fromLTWH(0, 12, 6, 5), paint);
        canvas.drawRect(Rect.fromLTWH(24, 26, 6, 5), paint);
        canvas.drawRect(Rect.fromLTWH(0, 40, 6, 5), paint);

      case ObstacleType.pterodactyl:
        paint.color = const Color(0xFF757575);
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(0, 5, 40, 20), const Radius.circular(5)),
          paint,
        );
        paint.color = const Color(0xFF616161);
        canvas.drawRect(Rect.fromLTWH(2, 5, 36, 20), paint);
        paint.color = const Color(0xFF9E9E9E);

        final wingUp = (DateTime.now().millisecondsSinceEpoch ~/ 200).isEven;
        if (wingUp) {
          final wingPath = Path()
            ..moveTo(8, 5)
            ..lineTo(20, -10)
            ..lineTo(30, 5)
            ..close();
          canvas.drawPath(wingPath, paint);
        } else {
          final wingPath = Path()
            ..moveTo(8, 5)
            ..lineTo(20, -5)
            ..lineTo(30, 5)
            ..close();
          canvas.drawPath(wingPath, paint);
        }

        paint.color = const Color(0xFFFFCC00);
        canvas.drawCircle(const Offset(6, 14), 2, paint);
        paint.color = const Color(0xFF222222);
        canvas.drawCircle(const Offset(6, 14), 1, paint);

        paint.color = const Color(0xFFFF6600);
        final beakPath = Path()
          ..moveTo(0, 14)
          ..lineTo(-4, 12)
          ..lineTo(-4, 16)
          ..close();
        canvas.drawPath(beakPath, paint);
    }
  }
}
