import 'dart:ui';
import 'package:flame/components.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

class HealthBarComponent extends PositionComponent {
  double _currentHealth;
  double _maxHealth;
  double _targetHealth;
  double _smoothHealth;
  final double _width;
  final double _height;
  final Color _backgroundColor;
  final Color _fillColor;
  final Color _lowHealthColor;
  final Color _smoothColor;
  final bool _showBackground;
  final bool _smoothTransition;

  HealthBarComponent({
    Vector2? position,
    double currentHealth = 100.0,
    double maxHealth = 100.0,
    double width = 40.0,
    double height = 5.0,
    Color? backgroundColor,
    Color? fillColor,
    Color? lowHealthColor,
    Color? smoothColor,
    this._showBackground = true,
    this._smoothTransition = true,
  })  : _currentHealth = currentHealth,
        _maxHealth = maxHealth,
        _targetHealth = currentHealth,
        _smoothHealth = currentHealth,
        _width = width,
        _height = height,
        _backgroundColor = backgroundColor ?? const Color(0x40FFFFFF),
        _fillColor = fillColor ?? Colors.green,
        _lowHealthColor = lowHealthColor ?? Colors.red,
        _smoothColor = smoothColor ?? Colors.orange.withOpacity(0.5),
        super(position: position, size: Vector2(width, height));

  void updateHealth(double current, double max) {
    _currentHealth = current;
    _maxHealth = max;
    _targetHealth = current;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_smoothTransition) {
      _smoothHealth += (_targetHealth - _smoothHealth) * 5.0 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_maxHealth <= 0) return;
    final ratio = (_currentHealth / _maxHealth).clamp(0.0, 1.0);
    final smoothRatio = (_smoothHealth / _maxHealth).clamp(0.0, 1.0);
    final isLow = ratio < 0.3;

    // Background
    if (_showBackground) {
      final bgPaint = Paint()
        ..color = _backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, _width, _height),
          const Radius.circular(2),
        ),
        bgPaint,
      );
    }

    // Smooth transition bar (delayed)
    if (_smoothTransition && smoothRatio > ratio) {
      final smoothPaint = Paint()
        ..color = _smoothColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, _width * smoothRatio, _height),
          const Radius.circular(2),
        ),
        smoothPaint,
      );
    }

    // Health fill
    if (ratio > 0) {
      final fillPaint = Paint()
        ..color = isLow ? _lowHealthColor : _fillColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, _width * ratio, _height),
          const Radius.circular(2),
        ),
        fillPaint,
      );
    }

    // Border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, _width, _height),
        const Radius.circular(2),
      ),
      borderPaint,
    );
  }
}
