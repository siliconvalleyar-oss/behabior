import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/core/entities/dino.dart';
import 'package:behabior/core/entities/obstacle.dart';
import 'package:behabior/core/entities/ground.dart';
import 'package:behabior/core/entities/cloud.dart';
import 'package:behabior/core/systems/score_system.dart';

class DinoGame extends FlameGame with TapCallbacks {
  late Dino _dino;
  late Ground _ground;
  late ScoreSystem _scoreSystem;
  final List<Obstacle> _obstacles = [];
  final List<Cloud> _clouds = [];
  double _spawnTimer = 1.5;
  bool _gameOver = false;
  bool _started = false;
  final Random _random = Random();

  @override
  Color backgroundColor() => const Color(0xFFF7F7F7);

  @override
  Future<void> onLoad() async {
    _dino = Dino();
    _ground = Ground();
    _scoreSystem = ScoreSystem();

    add(_ground);
    add(_dino);
    _spawnCloud();
  }

  void _spawnCloud() {
    final cloud = Cloud(worldWidth: size.x, speed: _scoreSystem.speed);
    _clouds.add(cloud);
    add(cloud);
  }

  void _spawnObstacle() {
    final obstacle = Obstacle.random(_scoreSystem.speed);
    _obstacles.add(obstacle);
    add(obstacle);
  }

  void startGame() {
    _started = true;
    _gameOver = false;
    _scoreSystem.reset();
    _dino = Dino();
    _ground = Ground();
    _obstacles.clear();
    _clouds.clear();
    _spawnTimer = 1.5;
    removeAll(children);

    add(_ground);
    add(_dino);
    _spawnCloud();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_started) {
      startGame();
      return;
    }
    if (_gameOver) {
      startGame();
      return;
    }
    _dino.jump();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_started || _gameOver) return;

    _scoreSystem.update(dt);
    _ground.scroll(_scoreSystem.speed, dt);
    _dino.updatePhysics(dt, _scoreSystem.speed);

    _spawnTimer -= dt;
    if (_spawnTimer <= 0) {
      _spawnTimer = _random.nextDouble() * (GameConfig.obstacleSpawnMax - GameConfig.obstacleSpawnMin) +
          GameConfig.obstacleSpawnMin;
      _spawnObstacle();
    }

    for (final obstacle in _obstacles) {
      obstacle.move(_scoreSystem.speed, dt);
    }
    _obstacles.removeWhere((o) {
      if (o.isOffScreen) {
        o.removeFromParent();
        return true;
      }
      return false;
    });

    for (final o in _obstacles) {
      if (!o.passed && o.position.x + o.size.x < GameConfig.dinoX) {
        o.passed = true;
        _scoreSystem.score += 10;
      }
    }

    if (_clouds.length < 3) {
      if (_random.nextDouble() < 0.01) {
        _spawnCloud();
      }
    }
    _clouds.removeWhere((c) {
      if (c.isOffScreen) {
        c.removeFromParent();
        return true;
      }
      return false;
    });

    _checkCollisions();
  }

  void _checkCollisions() {
    final dinoRect = _dino.toAbsoluteRect();
    final margin = 6.0;
    final dinoHitbox = dinoRect.deflate(margin);

    for (final o in _obstacles) {
      final obstacleRect = o.toAbsoluteRect();
      if (dinoHitbox.overlaps(obstacleRect)) {
        _gameOver = true;
        _dino.die();
        _scoreSystem.checkHighScore();
        break;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final textStyle = TextStyle(
      fontSize: 18,
      color: const Color(0xFF535353),
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
    );

    final scoreStr = _scoreSystem.score.toString().padLeft(5, '0');
    final highScoreStr = _scoreSystem.highScore.toString().padLeft(5, '0');

    if (_started) {
      if (_scoreSystem.highScore > 0) {
        final hiText = TextPainter(
          text: TextSpan(text: 'HI ', style: textStyle.copyWith(fontSize: 10)),
          textDirection: TextDirection.ltr,
        )..layout();
        hiText.paint(canvas, Offset(size.x - 200, 10));

        final highScoreText = TextPainter(
          text: TextSpan(text: highScoreStr, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        highScoreText.paint(canvas, Offset(size.x - 180, 8));
      }

      final scoreText = TextPainter(
        text: TextSpan(text: scoreStr, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      scoreText.paint(canvas, Offset(size.x - 100, 8));
    }

    if (!_started) {
      final startText = TextPainter(
        text: TextSpan(text: 'TAP TO START', style: textStyle.copyWith(fontSize: 20)),
        textDirection: TextDirection.ltr,
      )..layout();
      startText.paint(
        canvas,
        Offset(
          (size.x - startText.width) / 2,
          (size.y - startText.height) / 2,
        ),
      );
    }

    if (_gameOver) {
      final gameOverText = TextPainter(
        text: TextSpan(
          text: 'GAME OVER',
          style: textStyle.copyWith(fontSize: 24, color: const Color(0xFF535353)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      gameOverText.paint(
        canvas,
        Offset(
          (size.x - gameOverText.width) / 2,
          (size.y - gameOverText.height) / 2 - 20,
        ),
      );

      final restartText = TextPainter(
        text: TextSpan(text: 'TAP TO RESTART', style: textStyle.copyWith(fontSize: 16)),
        textDirection: TextDirection.ltr,
      )..layout();
      restartText.paint(
        canvas,
        Offset(
          (size.x - restartText.width) / 2,
          (size.y - restartText.height) / 2 + 20,
        ),
      );
    }
  }
}
