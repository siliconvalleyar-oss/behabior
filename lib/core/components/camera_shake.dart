import 'package:flame/components.dart';
import 'package:flame/camera.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;
import 'package:behabior/core/config/game_config.dart';

class CameraShakeEffect {
  final CameraComponent _camera;
  bool _isShaking = false;
  double _shakeDuration = 0.0;
  double _shakeTimer = 0.0;
  double _shakeIntensity = 5.0;
  Vector2 _originalOffset = Vector2.zero();

  CameraShakeEffect(this._camera);

  void shake({
    double intensity = GameConfig.cameraShakeIntensity,
    double duration = GameConfig.cameraShakeDuration,
  }) {
    _shakeIntensity = intensity;
    _shakeDuration = duration;
    _shakeTimer = 0.0;
    _isShaking = true;
    _originalOffset = _camera.offset;
  }

  void update(double dt) {
    if (!_isShaking) return;

    _shakeTimer += dt;
    if (_shakeTimer >= _shakeDuration) {
      _isShaking = false;
      _camera.moveTo(_originalOffset);
      return;
    }

    // Decay intensity over time
    final decay = 1.0 - (_shakeTimer / _shakeDuration);
    final intensity = _shakeIntensity * decay;

    // Random shake offset
    final shakeOffset = Vector2(
      (DateTime.now().millisecondsSinceEpoch % 1000 - 500) / 500.0 * intensity,
      (DateTime.now().millisecondsSinceEpoch % 1000 - 500) / 500.0 * intensity,
    );

    _camera.moveTo(_originalOffset + shakeOffset);
  }

  bool get isShaking => _isShaking;
}
