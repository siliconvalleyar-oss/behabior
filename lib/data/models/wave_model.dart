import 'package:equatable/equatable.dart';

class WaveModel extends Equatable {
  final int waveNumber;
  final int enemyCount;
  final String enemyType;
  final double spawnInterval;
  final bool hasBoss;
  final String? bossType;

  const WaveModel({
    required this.waveNumber,
    required this.enemyCount,
    required this.enemyType,
    required this.spawnInterval,
    this.hasBoss = false,
    this.bossType,
  });

  @override
  List<Object?> get props => [waveNumber, enemyCount, enemyType, spawnInterval, hasBoss, bossType];
}
