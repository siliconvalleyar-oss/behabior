import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

enum DinoState { running, jumping, ducking, dead }

class Dino extends PositionComponent {
  DinoState dinoState = DinoState.running;
  double velocityY = 0;
  double _frameTimer = 0;
  int _frameIndex = 0;
  bool _jumpHeld = false;
  double jumpHoldTime = 0;

  Dino() : super(size: Vector2(GameConfig.dinoWidth, GameConfig.dinoHeight));

  @override
  Future<void> onLoad() async {
    position.setValues(GameConfig.dinoX, GameConfig.dinoY);
  }

  void jump() {
    if (dinoState != DinoState.running && dinoState != DinoState.ducking) return;
    dinoState = DinoState.jumping;
    velocityY = GameConfig.jumpVelocity;
    _jumpHeld = true;
    jumpHoldTime = 0;
  }

  void duck() {
    if (dinoState == DinoState.jumping) return;
    dinoState = DinoState.ducking;
    size.y = GameConfig.duckingHeight;
    position.y = GameConfig.groundY - GameConfig.duckingHeight;
  }

  void standUp() {
    if (dinoState != DinoState.ducking) return;
    dinoState = DinoState.running;
    size.y = GameConfig.dinoHeight;
    position.y = GameConfig.dinoY;
  }

  void die() {
    dinoState = DinoState.dead;
  }

  void updatePhysics(double dt, double speed) {
    if (dinoState == DinoState.dead) return;

    if (dinoState == DinoState.jumping) {
      velocityY += GameConfig.gravity;
      position.y += velocityY;

      if (_jumpHeld) {
        jumpHoldTime += dt;
        if (jumpHoldTime > 0.3) _jumpHeld = false;
      }

      if (position.y >= GameConfig.dinoY) {
        position.y = GameConfig.dinoY;
        velocityY = 0;
        dinoState = DinoState.running;
      }
    }

    if (dinoState == DinoState.running) {
      _frameTimer += dt * speed * 0.5;
      if (_frameTimer >= 0.5) {
        _frameTimer = 0;
        _frameIndex = (_frameIndex + 1) % 2;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint();

    if (dinoState == DinoState.dead) {
      _drawRunningDino(canvas, paint, 0);
      _drawEye(canvas, paint, true);
      return;
    }

    if (dinoState == DinoState.ducking) {
      _drawDuckingDino(canvas, paint, _frameIndex);
      return;
    }

    if (dinoState == DinoState.running) {
      _drawRunningDino(canvas, paint, _frameIndex);
      _drawLeg(canvas, paint, _frameIndex);
    } else {
      _drawRunningDino(canvas, paint, 0);
      _drawLeg(canvas, paint, 0);
    }

    _drawEye(canvas, paint, false);
  }

  void _drawRunningDino(Canvas canvas, Paint paint, int frame) {
    paint.color = const Color(0xFF535353);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, 40, 44),
        const Radius.circular(4),
      ),
      paint,
    );

    paint.color = const Color(0xFF6B6B6B);
    canvas.drawRect(Rect.fromLTWH(0, 0, 40, 22), paint);

    final mouthPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawRect(Rect.fromLTWH(0, 20, 6, 4), mouthPaint);

    paint.color = const Color(0xFF535353);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(12, 8, 6, 8),
        const Radius.circular(3),
      ),
      paint,
    );

    paint.color = const Color(0xFF888888);
    canvas.drawRect(Rect.fromLTWH(6, 6, 4, 4), paint);
    canvas.drawRect(Rect.fromLTWH(6, 8, 4, 2), paint);
  }

  void _drawEye(Canvas canvas, Paint paint, bool dead) {
    paint.color = dead ? const Color(0xFFCC0000) : const Color(0xFF222222);
    canvas.drawCircle(const Offset(32, 14), 3, paint);
    if (!dead) {
      paint.color = const Color(0xFFFFFFFF);
      canvas.drawCircle(const Offset(33, 13), 1, paint);
    }
  }

  void _drawLeg(Canvas canvas, Paint paint, int frame) {
    paint.color = const Color(0xFF535353);
    if (frame == 0) {
      canvas.drawRect(Rect.fromLTWH(12, 42, 6, 6), paint);
      canvas.drawRect(Rect.fromLTWH(28, 42, 6, 6), paint);
    } else {
      canvas.drawRect(Rect.fromLTWH(10, 42, 8, 4), paint);
      canvas.drawRect(Rect.fromLTWH(28, 44, 6, 4), paint);
    }
  }

  void _drawDuckingDino(Canvas canvas, Paint paint, int frame) {
    paint.color = const Color(0xFF535353);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, 52, 28),
        const Radius.circular(4),
      ),
      paint,
    );

    paint.color = const Color(0xFF6B6B6B);
    canvas.drawRect(Rect.fromLTWH(0, 0, 52, 14), paint);

    paint.color = const Color(0xFF222222);
    canvas.drawCircle(const Offset(44, 10), 3, paint);
    paint.color = const Color(0xFFFFFFFF);
    canvas.drawCircle(const Offset(45, 9), 1, paint);

    paint.color = const Color(0xFF535353);
    if (frame == 0) {
      canvas.drawRect(Rect.fromLTWH(14, 26, 6, 4), paint);
      canvas.drawRect(Rect.fromLTWH(34, 26, 6, 4), paint);
    } else {
      canvas.drawRect(Rect.fromLTWH(12, 26, 8, 3), paint);
      canvas.drawRect(Rect.fromLTWH(34, 28, 6, 3), paint);
    }
  }
}
