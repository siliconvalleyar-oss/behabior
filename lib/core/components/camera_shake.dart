import 'dart:math';
import 'package:flame/components.dart';

class CameraShakeEffect extends Component {
  double _intensity = 0;
  double _duration = 0;
  double _elapsed = 0;
  final Random _random = Random();
  bool _isShaking = false;

  void trigger({double intensity = 5.0, double duration = 0.15}) {
    _intensity = intensity;
    _duration = duration;
    _elapsed = 0;
    _isShaking = true;
  }

  bool get isShaking => _isShaking;

  Vector2 get offset {
    if (!_isShaking) return Vector2.zero();
    return Vector2(
      (_random.nextDouble() - 0.5) * 2 * _intensity * (1 - _elapsed / _duration),
      (_random.nextDouble() - 0.5) * 2 * _intensity * (1 - _elapsed / _duration),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isShaking) {
      _elapsed += dt;
      if (_elapsed >= _duration) {
        _isShaking = false;
        _intensity = 0;
      }
    }
  }
}
