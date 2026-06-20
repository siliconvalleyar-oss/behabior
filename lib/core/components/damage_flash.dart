import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

class DamageFlashComponent extends PositionComponent {
  double _timer = 0;

  void flash({double duration = 0.1}) {
    _timer = duration;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_timer > 0) {
      _timer -= dt;
    }
  }

  bool get isFlashing => _timer > 0;

  @override
  void render(Canvas canvas) {
    if (_timer <= 0) return;
    final paint = Paint()..color = GameConfig.damageFlashColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
  }
}
