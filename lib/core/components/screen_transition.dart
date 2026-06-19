import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;

enum TransitionType { fadeIn, fadeOut, fadeInOut }

class ScreenTransition extends Component {
  TransitionType _type = TransitionType.fadeIn;
  double _duration = 0.5;
  double _timer = 0.0;
  bool _isActive = false;
  double _alpha = 0.0;
  VoidCallback? _onComplete;
  Color _color = Colors.black;

  bool get isActive => _isActive;
  double get progress => (_timer / _duration).clamp(0.0, 1.0);

  void startFadeIn({
    double duration = 0.5,
    VoidCallback? onComplete,
    Color? color,
  }) {
    _type = TransitionType.fadeIn;
    _duration = duration;
    _timer = 0.0;
    _alpha = 1.0;
    _onComplete = onComplete;
    _isActive = true;
    _color = color ?? Colors.black;
  }

  void startFadeOut({
    double duration = 0.5,
    VoidCallback? onComplete,
    Color? color,
  }) {
    _type = TransitionType.fadeOut;
    _duration = duration;
    _timer = 0.0;
    _alpha = 0.0;
    _onComplete = onComplete;
    _isActive = true;
    _color = color ?? Colors.black;
  }

  void startFadeInOut({
    double duration = 0.5,
    double holdDuration = 0.3,
    VoidCallback? onComplete,
    Color? color,
  }) {
    // Simplified: just fade in
    startFadeIn(duration: duration, onComplete: onComplete, color: color);
  }

  @override
  void update(double dt) {
    if (!_isActive) return;

    _timer += dt;
    final p = progress;

    switch (_type) {
      case TransitionType.fadeIn:
        _alpha = 1.0 - p;
        if (_timer >= _duration) {
          _alpha = 0.0;
          _isActive = false;
          _onComplete?.call();
        }
        break;
      case TransitionType.fadeOut:
        _alpha = p;
        if (_timer >= _duration) {
          _alpha = 1.0;
          _isActive = false;
          _onComplete?.call();
        }
        break;
      case TransitionType.fadeInOut:
        // Simple fade in
        _alpha = 1.0 - p;
        if (_timer >= _duration) {
          _alpha = 0.0;
          _isActive = false;
          _onComplete?.call();
        }
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_isActive && _alpha <= 0) return;
    final paint = Paint()
      ..color = _color.withOpacity(_alpha.clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 2000, 2000), // Large enough for any screen
      paint,
    );
  }
}
