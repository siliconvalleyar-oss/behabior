import 'dart:math';
import 'package:behabior/core/config/game_config.dart';
import 'package:behabior/data/models/enemy_model.dart';
import 'package:behabior/data/models/wave_model.dart';

class SpawnEngine {
  final Random _random = Random();

  List<SpawnInstruction> generateWaveSpawns(WaveModel wave) {
    final instructions = <SpawnInstruction>[];
    final count = wave.enemyCount;

    if (wave.hasBoss) {
      instructions.add(SpawnInstruction(type: 'boss', x: GameConfig.worldWidth / 2, y: -60));
      return instructions;
    }

    for (int i = 0; i < count; i++) {
      final offset = _random.nextDouble() * 100 - 50;
      final (double, double) pos = _randomEdgePosition();
      instructions.add(SpawnInstruction(
        type: wave.enemyType,
        x: pos.$1 + offset,
        y: pos.$2 + offset,
      ));
    }
    return instructions;
  }

  (double, double) _randomEdgePosition() {
    final edge = _random.nextInt(4);
    return switch (edge) {
      0 => (_random.nextDouble() * GameConfig.worldWidth, -GameConfig.spawnMargin),
      1 => (_random.nextDouble() * GameConfig.worldWidth, GameConfig.worldHeight + GameConfig.spawnMargin),
      2 => (-GameConfig.spawnMargin, _random.nextDouble() * GameConfig.worldHeight),
      3 => (GameConfig.worldWidth + GameConfig.spawnMargin, _random.nextDouble() * GameConfig.worldHeight),
      _ => (0.0, 0.0),
    };
  }
}

class SpawnInstruction {
  final String type;
  final double x;
  final double y;

  const SpawnInstruction({required this.type, required this.x, required this.y});
}
