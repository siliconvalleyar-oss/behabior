import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart' as rive;

/// Wrapper around Rive animations for sprite rendering.
/// Supports state machine driven animations.
class RiveSpriteComponent extends PositionComponent {
  final String _assetPath;
  final String? _animationName;
  rive.Artboard? _artboard;
  rive.StateMachineController? _stateMachine;
  rive.SMAInput? _inputSpeed;
  rive.SMAInput? _inputDirection;
  rive.SMAInput? _inputAttack;
  rive.SMAInput? _inputHit;
  rive.SMAInput? _inputDeath;
  bool _loaded = false;
  bool _loop = true;
  double _speed = 1.0;

  RiveSpriteComponent({
    required String assetPath,
    String? animationName,
    Vector2? position,
    Vector2? size,
  })  : _assetPath = assetPath,
        _animationName = animationName,
        super(position: position, size: size);

  Future<void> load() async {
    if (_loaded) return;
    try {
      final file = await rive.RiveFile.asset(_assetPath);
      _artboard = file.mainArtboard;
      if (_artboard == null) return;

      // Try to create state machine
      _stateMachine = rive.StateMachineController.fromArtboard(
        _artboard!,
        _animationName ?? 'State Machine',
      );
      if (_stateMachine != null) {
        _artboard!.addController(_stateMachine!);
        _setupInputs();
      }
      _loaded = true;
    } catch (e) {
      _loaded = false;
    }
  }

  void _setupInputs() {
    _inputSpeed = _stateMachine?.inputs.firstWhere(
      (i) => i.name == 'speed',
      orElse: () => _stateMachine!.inputs.first,
    );
    _inputDirection = _stateMachine?.inputs.firstWhere(
      (i) => i.name == 'direction',
      orElse: () => _stateMachine!.inputs.first,
    );
    _inputAttack = _stateMachine?.inputs.firstWhere(
      (i) => i.name == 'attack',
      orElse: () => _stateMachine!.inputs.first,
    );
    _inputHit = _stateMachine?.inputs.firstWhere(
      (i) => i.name == 'hit',
      orElse: () => _stateMachine!.inputs.first,
    );
    _inputDeath = _stateMachine?.inputs.firstWhere(
      (i) => i.name == 'death',
      orElse: () => _stateMachine!.inputs.first,
    );
  }

  void setSpeed(double value) {
    _speed = value;
    _inputSpeed?.value = value;
  }

  void setDirection(double value) {
    _inputDirection?.value = value;
  }

  void triggerAttack() {
    _inputAttack?.value = 1.0;
    Future.delayed(const Duration(milliseconds: 100), () {
      _inputAttack?.value = 0.0;
    });
  }

  void triggerHit() {
    _inputHit?.value = 1.0;
    Future.delayed(const Duration(milliseconds: 200), () {
      _inputHit?.value = 0.0;
    });
  }

  void triggerDeath() {
    _inputDeath?.value = 1.0;
  }

  @override
  void render(Canvas canvas) {
    if (_artboard == null || !_loaded) return;
    final bounds = size.isZero()
        ? Rect.fromLTWH(0, 0, 100, 100)
        : Rect.fromLTWH(0, 0, size.x, size.y);
    _artboard!.draw(canvas, bounds);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_artboard != null && _loaded) {
      _artboard!.advance(dt * _speed);
    }
  }

  bool get isLoaded => _loaded;
}
