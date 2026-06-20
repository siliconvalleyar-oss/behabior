import 'package:equatable/equatable.dart';
import 'package:behabior/data/models/wave_model.dart';

class LevelModel extends Equatable {
  final int id;
  final String name;
  final int starRequirement;
  final List<WaveModel> waves;

  const LevelModel({
    required this.id,
    required this.name,
    this.starRequirement = 0,
    this.waves = const [],
  });

  LevelModel copyWith({int? id, String? name, int? starRequirement, List<WaveModel>? waves}) {
    return LevelModel(
      id: id ?? this.id,
      name: name ?? this.name,
      starRequirement: starRequirement ?? this.starRequirement,
      waves: waves ?? this.waves,
    );
  }

  @override
  List<Object?> get props => [id, name, starRequirement, waves];

  static const List<LevelModel> defaults = [
    LevelModel(
      id: 1,
      name: 'The Beginning',
      starRequirement: 0,
      waves: [
        WaveModel(waveNumber: 1, enemyCount: 5, enemyType: 'grunt', spawnInterval: 2.0),
        WaveModel(waveNumber: 2, enemyCount: 2, enemyType: 'runner', spawnInterval: 1.5),
        WaveModel(waveNumber: 3, enemyCount: 8, enemyType: 'grunt', spawnInterval: 1.8),
        WaveModel(waveNumber: 4, enemyCount: 3, enemyType: 'runner', spawnInterval: 1.2),
        WaveModel(waveNumber: 5, enemyCount: 1, enemyType: 'boss', spawnInterval: 1.0, hasBoss: true, bossType: 'phase_boss'),
      ],
    ),
  ];
}
