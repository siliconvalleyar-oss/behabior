import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:behabior/core/entities/player.dart';

class GameJoystick extends Component with TapCallbacks, DragCallbacks {
  final Player player;
  final VoidCallback? onFire;

  final Rect _joystickArea = const Rect.fromLTWH(20, 420, 160, 160);
  final Rect _fireButtonArea = const Rect.fromLTWH(620, 440, 120, 120);
  Vector2 _joystickDelta = Vector2.zero();
  bool _isDragging = false;

  GameJoystick({
    required this.player,
    this.onFire,
  });

  @override
  bool containsLocalPoint(Vector2 point) {
    return _joystickArea.containsPoint(point) || _fireButtonArea.containsPoint(point);
  }

  @override
  void render(Canvas canvas) {
    final bgPaint = Paint()
      ..color = const Color(0x446C5CE7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      Offset(_joystickArea.center.dx, _joystickArea.center.dy),
      _joystickArea.width / 2,
      bgPaint,
    );

    final borderPaint = Paint()
      ..color = const Color(0x886C5CE7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(_joystickArea.center.dx, _joystickArea.center.dy),
      _joystickArea.width / 2,
      borderPaint,
    );

    if (_isDragging) {
      final knobPaint = Paint()..color = const Color(0xFF6C5CE7);
      canvas.drawCircle(
        Offset(
          _joystickArea.center.dx + _joystickDelta.x,
          _joystickArea.center.dy + _joystickDelta.y,
        ),
        20,
        knobPaint,
      );
    }

    final firePaint = Paint()..color = const Color(0x44E74C3C);
    canvas.drawCircle(
      Offset(_fireButtonArea.center.dx, _fireButtonArea.center.dy),
      _fireButtonArea.width / 2,
      firePaint,
    );
    final fireBorder = Paint()
      ..color = const Color(0x88E74C3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(_fireButtonArea.center.dx, _fireButtonArea.center.dy),
      _fireButtonArea.width / 2,
      fireBorder,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: '⚡',
        style: const TextStyle(color: Color(0xFFE74C3C), fontSize: 36),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(
        _fireButtonArea.center.dx - textPainter.width / 2,
        _fireButtonArea.center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (_joystickArea.containsPoint(event.canvasPosition)) {
      _isDragging = true;
      _updateJoystick(event.canvasPosition);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_isDragging) {
      _updateJoystick(event.canvasEndPosition);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _isDragging = false;
    _joystickDelta = Vector2.zero();
    player.moveDirection = Vector2.zero();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_fireButtonArea.containsPoint(event.canvasPosition)) {
      if (player.canFire()) {
        player.fire();
        onFire?.call();
      }
    }
  }

  void _updateJoystick(Vector2 pos) {
    final center = _joystickArea.center;
    final dx = pos.x - center.dx;
    final dy = pos.y - center.dy;
    final dist = sqrt(dx * dx + dy * dy);
    final maxDist = _joystickArea.width / 2 - 10;

    if (dist > maxDist) {
      _joystickDelta.setValues(dx / dist * maxDist, dy / dist * maxDist);
    } else {
      _joystickDelta.setValues(dx, dy);
    }

    player.moveDirection = Vector2(
      _joystickDelta.x / maxDist,
      _joystickDelta.y / maxDist,
    );
  }
}
