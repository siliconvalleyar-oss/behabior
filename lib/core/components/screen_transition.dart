import 'dart:ui';
import 'package:flame/components.dart';
import 'package:behabior/core/config/game_config.dart';

class ScreenTransition extends Component {
  TransitionState _state = TransitionState.idle;
  double _progress = 0;
  double _duration = GameConfig.fadeTransitionDuration;
  VoidCallback? _onComplete;

  void fadeIn({double? duration, VoidCallback? onComplete}) {
    _state = TransitionState.fadingIn;
    _progress = 1.0;
    _duration = duration ?? GameConfig.fadeTransitionDuration;
    _onComplete = onComplete;
  }

  void fadeOut({double? duration, VoidCallback? onComplete}) {
    _state = TransitionState.fadingOut;
    _progress = 0;
    _duration = duration ?? GameConfig.fadeTransitionDuration;
    _onComplete = onComplete;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_state == TransitionState.fadingIn) {
      _progress -= dt / _duration;
      if (_progress <= 0) {
        _progress = 0;
        _state = TransitionState.idle;
        _onComplete?.call();
      }
    } else if (_state == TransitionState.fadingOut) {
      _progress += dt / _duration;
      if (_progress >= 1) {
        _progress = 1;
        _state = TransitionState.idle;
        _onComplete?.call();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (_progress <= 0) return;
    final alpha = (_progress * 255).toInt();
    final paint = Paint()
      ..color = GameConfig.screenTransitionColor.withAlpha(alpha);
    canvas.drawRect(Rect.largest, paint);
  }

  bool get isTransitioning => _state != TransitionState.idle;
}

enum TransitionState { idle, fadingIn, fadingOut }
