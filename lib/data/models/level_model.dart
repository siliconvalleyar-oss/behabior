import 'package:equatable/equatable.dart';

class LevelModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final int waves;
  final List<WaveModel> waveConfigs;
  final String backgroundAsset;
  final bool isUnlocked;
  final int starRating;
  final double difficultyMultiplier;

  const LevelModel({
    required this.id,
    required this.name,
    required this.description,
    required this.waves,
    this.waveConfigs = const [],
    this.backgroundAsset = 'backgrounds/level_default.png',
    this.isUnlocked = false,
    this.starRating = 0,
    this.difficultyMultiplier = 1.0,
  });

  LevelModel copyWith({
    int? id,
    String? name,
    String? description,
    int? waves,
    List<WaveModel>? waveConfigs,
    String? backgroundAsset,
    bool? isUnlocked,
    int? starRating,
    double? difficultyMultiplier,
  }) {
    return LevelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      waves: waves ?? this.waves,
      waveConfigs: waveConfigs ?? this.waveConfigs,
      backgroundAsset: backgroundAsset ?? this.backgroundAsset,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      starRating: starRating ?? this.starRating,
      difficultyMultiplier: difficultyMultiplier ?? this.difficultyMultiplier,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        waves,
        waveConfigs,
        backgroundAsset,
        isUnlocked,
        starRating,
        difficultyMultiplier,
      ];
}

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
    this.enemyType = 'basic',
    this.spawnInterval = 2.0,
    this.hasBoss = false,
    this.bossType,
  });

  @override
  List<Object?> get props => [
        waveNumber,
        enemyCount,
        enemyType,
        spawnInterval,
        hasBoss,
        bossType,
      ];
}
