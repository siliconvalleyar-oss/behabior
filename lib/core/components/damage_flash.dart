import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

class DamageFlashComponent extends Component {
  final Color _flashColor = GameConfig.damageFlashColor;
  double _flashTimer = 0.0;
  bool _isFlashing = false;
  double _flashDuration = GameConfig.damageFlashDuration;
  double _currentAlpha = 0.0;

  void flash({double? duration, Color? color}) {
    _flashDuration = duration ?? GameConfig.damageFlashDuration;
    _flashTimer = 0.0;
    _isFlashing = true;
    _currentAlpha = 1.0;
  }

  @override
  void update(double dt) {
    if (!_isFlashing) return;
    _flashTimer += dt;
    _currentAlpha = 1.0 - (_flashTimer / _flashDuration);
    if (_flashTimer >= _flashDuration) {
      _isFlashing = false;
      _currentAlpha = 0.0;
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_isFlashing || _currentAlpha <= 0) return;
    final paint = Paint()
      ..color = _flashColor.withOpacity(_currentAlpha * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, 800, 600), // Will be resized by parent
      paint,
    );
  }

  bool get isFlashing => _isFlashing;
}
