import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

enum DinoState { running, jumping, ducking, dead }

class Dino extends PositionComponent {
  DinoState dinoState = DinoState.running;
  double velocityY = 0;
  int _frameIndex = 0;
  double _frameTimer = 0;
  bool _jumpHeld = false;
  double _holdTime = 0;

  Sprite? _run0;
  Sprite? _run1;
  Sprite? _run2;
  Sprite? _run3;
  Sprite? _run4;
  Sprite? _run5;
  Sprite? _run6;
  Sprite? _run7;
  Sprite? _dead;

  Dino() : super(size: Vector2(70, 72));

  @override
  Future<void> onLoad() async {
    try {
      _run0 = await Sprite.load('images/dino/dino_move_00.png');
      _run1 = await Sprite.load('images/dino/dino_move_01.png');
      _run2 = await Sprite.load('images/dino/dino_move_02.png');
      _run3 = await Sprite.load('images/dino/dino_move_03.png');
      _run4 = await Sprite.load('images/dino/dino_move_04.png');
      _run5 = await Sprite.load('images/dino/dino_move_05.png');
      _run6 = await Sprite.load('images/dino/dino_move_06.png');
      _run7 = await Sprite.load('images/dino/dino_move_07.png');
      _dead = await Sprite.load('images/dino/dino_08.png');
    } catch (_) {}
    x = GameConfig.dinoX;
    y = GameConfig.groundY - height;
  }

  void jump() {
    if (dinoState != DinoState.running && dinoState != DinoState.ducking) return;
    dinoState = DinoState.jumping;
    velocityY = GameConfig.jumpVelocity;
    _jumpHeld = true;
    _holdTime = 0;
  }

  void releaseJump() {
    _jumpHeld = false;
  }

  void die() {
    dinoState = DinoState.dead;
  }

  void updatePhysics(double dt) {
    if (dinoState == DinoState.dead) return;

    if (dinoState == DinoState.jumping) {
      velocityY += GameConfig.gravity;
      y += velocityY;

      if (_jumpHeld) {
        _holdTime += dt;
        if (_holdTime > 0.25) {
          velocityY += GameConfig.gravity * 0.5;
        }
      }

      if (y >= GameConfig.groundY - height) {
        y = GameConfig.groundY - height;
        velocityY = 0;
        dinoState = DinoState.running;
      }
    }

    if (dinoState == DinoState.running) {
      _frameTimer += dt * 12;
      if (_frameTimer >= 1) {
        _frameTimer = 0;
        _frameIndex = (_frameIndex + 1) % 8;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    Sprite? sprite;
    if (dinoState == DinoState.dead) {
      sprite = _dead;
    } else if (dinoState == DinoState.jumping) {
      sprite = _run0;
    } else {
      sprite = [
        _run0, _run1, _run2, _run3,
        _run4, _run5, _run6, _run7,
      ][_frameIndex];
    }

    if (sprite != null) {
      sprite.render(canvas, size: size);
    } else {
      final paint = Paint()..color = const Color(0xFF535353);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    }
  }
}
