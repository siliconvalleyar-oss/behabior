import 'dart:ui' show Canvas;
import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show Alignment;
import 'package:rive/rive.dart' as rive;

class RiveSpriteComponent extends PositionComponent {
  final String _assetPath;
  final String? _artboardName;
  final String? _stateMachineName;
  rive.Artboard? _artboard;
  rive.StateMachine? _stateMachine;
  bool _artboardLoaded = false;

  rive.NumberInput? _inputSpeed;
  rive.BooleanInput? _inputAttack;
  rive.BooleanInput? _inputHit;
  rive.TriggerInput? _inputDeath;
  rive.BooleanInput? _inputMoving;

  RiveSpriteComponent({
    required String assetPath,
    String? artboardName,
    String? stateMachineName,
    Vector2? position,
    Vector2? size,
  })  : _assetPath = assetPath,
        _artboardName = artboardName,
        _stateMachineName = stateMachineName,
        super(position: position, size: size);

  Future<void> load() async {
    if (_artboardLoaded) return;
    try {
      final file = await rive.File.asset(
        _assetPath,
        riveFactory: rive.Factory.rive,
      );
      if (file == null) return;
      _artboard = _artboardName != null
          ? file.artboard(_artboardName!)
          : file.defaultArtboard();
      if (_artboard == null) return;

      _stateMachine = _stateMachineName != null
          ? _artboard!.stateMachine(_stateMachineName!)
          : _artboard!.defaultStateMachine();
      if (_stateMachine != null) {
        _setupInputs();
        _artboard!.advance(0);
      }
      _artboardLoaded = true;
    } catch (e) {
      _artboardLoaded = false;
    }
  }

  void _setupInputs() {
    if (_stateMachine == null) return;
    _inputSpeed = _stateMachine!.number('speed');
    _inputAttack = _stateMachine!.boolean('attack');
    _inputHit = _stateMachine!.boolean('hit');
    _inputDeath = _stateMachine!.trigger('death');
    _inputMoving = _stateMachine!.boolean('moving');
  }

  void setSpeed(double value) {
    _inputSpeed?.value = value;
  }

  void triggerAttack() {
    _inputAttack?.value = true;
  }

  void resetAttack() {
    _inputAttack?.value = false;
  }

  void triggerHit() {
    _inputHit?.value = true;
  }

  void resetHit() {
    _inputHit?.value = false;
  }

  void triggerDeath() {
    _inputDeath?.fire();
  }

  void setMoving(bool value) {
    _inputMoving?.value = value;
  }

  @override
  void render(Canvas canvas) {
    if (_artboard == null || !_artboardLoaded) return;
    final renderer = rive.Renderer.make(canvas);
    try {
      final s = size.isZero() ? Vector2(100, 100) : size;
      final frame = rive.AABB.fromValues(0, 0, s.x, s.y);
      renderer.align(
        rive.Fit.contain,
        Alignment.center,
        frame,
        _artboard!.bounds,
        1.0,
      );
      _artboard!.draw(renderer);
    } finally {
      renderer.dispose();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_artboard != null && _artboardLoaded) {
      if (_stateMachine != null) {
        _stateMachine!.advanceAndApply(dt);
      } else {
        _artboard!.advance(dt);
      }
    }
  }

  bool get isLoaded => _artboardLoaded;
}
