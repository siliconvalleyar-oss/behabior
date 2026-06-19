import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:vector_math/vector_math.dart' hide Colors;

class JoystickComponent extends PositionComponent with DragCallbacks {
  final double knobRadius;
  final double backgroundRadius;
  late final Color backgroundColor;
  late final Color knobColor;
  late final Color activeColor;

  final Vector2 _knobPosition;
  final Vector2 _delta = Vector2.zero();
  bool _isDragging = false;
  bool _isVisible = true;

  void Function(Vector2 direction)? onDirectionChanged;

  JoystickComponent({
    this.knobRadius = 30.0,
    this.backgroundRadius = 80.0,
    this.knobColor = const Color(0x80FFFFFF),
    this.activeColor = const Color(0xB0FFFFFF),
    Vector2? position,
    double? size,
  }) : _knobPosition = position ?? Vector2.zero(),
       super(position: position ?? Vector2.zero(), size: Vector2(size ?? 300, size ?? 300));

  @override
  void onMount() {
    super.onMount();
    _knobPosition.setFrom(this.position);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true;

  Vector2 get delta => _delta;
  bool get isDragging => _isDragging;

  void show() => _isVisible = true;
  void hide() => _isVisible = false;

  @override
  void onDragStart(DragStartEvent event) {
    if (!_isVisible) return;
    final startPos = event.canvasPosition;
    final dist = (startPos - position).length;
    if (dist <= backgroundRadius * 1.5) {
      _isDragging = true;
      _updateKnob(startPos);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging || !_isVisible) return;
    _updateKnob(event.canvasEndPosition);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!_isDragging) return;
    _isDragging = false;
    _knobPosition.setFrom(position);
    _delta.setZero();
    onDirectionChanged?.call(_delta);
  }

  void _updateKnob(Vector2 touchPos) {
    final diff = touchPos - position;
    final dist = diff.length;
    if (dist <= backgroundRadius) {
      _knobPosition.setFrom(touchPos);
      _delta.setFrom(diff / backgroundRadius);
    } else {
      _knobPosition
        ..setFrom(position + (diff / dist) * backgroundRadius);
      _delta.setFrom(diff / backgroundRadius);
    }
    if (_delta.length > 1.0) _delta.normalize();
    onDirectionChanged?.call(_delta);
  }

  @override
  void render(Canvas canvas) {
    if (!_isVisible) return;

    final bgPaint = Paint()
      ..color = _isDragging ? activeColor.withOpacity(0.3) : backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(position.x, position.y),
      backgroundRadius,
      bgPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(
      Offset(position.x, position.y),
      backgroundRadius,
      borderPaint,
    );

    final knobPaint = Paint()
      ..color = _isDragging ? activeColor : knobColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(_knobPosition.x, _knobPosition.y),
      knobRadius,
      knobPaint,
    );

    if (_delta.length > 0.1) {
      final indicatorPaint = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawLine(
        Offset(position.x, position.y),
        Offset(_knobPosition.x, _knobPosition.y),
        indicatorPaint,
      );
    }
  }
}
