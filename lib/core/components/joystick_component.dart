import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flame/palette.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

class JoystickComponent extends Component with Tappable, Draggable {
  final double knobRadius;
  final double backgroundRadius;
  final Color backgroundColor;
  final Color knobColor;
  final Color activeColor;

  Vector2 _knobPosition;
  Vector2 _delta = Vector2.zero();
  bool _isDragging = false;
  bool _isVisible = true;

  // Callback for direction
  void Function(Vector2 direction)? onDirectionChanged;

  JoystickComponent({
    this.knobRadius = 30.0,
    this.backgroundRadius = 80.0,
    this.backgroundColor = const Color(0x40FFFFFF),
    this.knobColor = const Color(0x80FFFFFF),
    this.activeColor = const Color(0xB0FFFFFF),
    Vector2? position,
  })  : _knobPosition = position ?? Vector2.zero(),
        super();

  @override
  void onMount() {
    super.onMount();
    _knobPosition = position;
  }

  @override
  void render(Canvas canvas) {
    if (!_isVisible) return;

    // Background circle
    final bgPaint = Paint()
      ..color = _isDragging ? activeColor.withOpacity(0.3) : backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(position.x, position.y),
      backgroundRadius,
      bgPaint,
    );

    // Background border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(
      Offset(position.x, position.y),
      backgroundRadius,
      borderPaint,
    );

    // Knob
    final knobPaint = Paint()
      ..color = _isDragging ? activeColor : knobColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(_knobPosition.x, _knobPosition.y),
      knobRadius,
      knobPaint,
    );

    // Direction indicator
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

  @override
  bool onTapUp(TapUpInfo info) {
    if (!_isVisible) return false;
    final tapPos = info.eventPosition.game;
    final dist = (tapPos - position).length;
    if (dist <= backgroundRadius) {
      _updateKnob(tapPos);
      return true;
    }
    return false;
  }

  @override
  bool onDragStart(DragStartInfo info) {
    if (!_isVisible) return false;
    final startPos = info.eventPosition.game;
    final dist = (startPos - position).length;
    if (dist <= backgroundRadius * 1.5) {
      _isDragging = true;
      _updateKnob(startPos);
      return true;
    }
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (!_isDragging || !_isVisible) return false;
    _updateKnob(info.eventPosition.game);
    return true;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    if (!_isDragging) return false;
    _isDragging = false;
    _knobPosition = position.clone();
    _delta = Vector2.zero();
    onDirectionChanged?.call(_delta);
    return true;
  }

  void _updateKnob(Vector2 touchPos) {
    final diff = touchPos - position;
    final dist = diff.length;
    if (dist <= backgroundRadius) {
      _knobPosition = touchPos;
      _delta = diff / backgroundRadius;
    } else {
      _knobPosition = position + (diff / dist) * backgroundRadius;
      _delta = diff / backgroundRadius;
    }
    // Normalize delta for direction
    if (_delta.length > 1.0) _delta.normalize();
    onDirectionChanged?.call(_delta);
  }

  Vector2 get delta => _delta;
  bool get isDragging => _isDragging;

  void show() => _isVisible = true;
  void hide() => _isVisible = false;
}
