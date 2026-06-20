import 'package:behabior/core/engine/spawn_engine.dart';
import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/data/models/wave_model.dart';

class WaveSystem {
  int _currentWave = 0;
  int _totalWaves = 0;
  int _currentLevelId = 1;

  void initLevel(int levelId, SpawnEngine spawnEngine) {
    _currentLevelId = levelId;
    _currentWave = 0;
    final level = LevelModel.defaults.firstWhere((l) => l.id == levelId);
    _totalWaves = level.waves.length;
  }

  WaveModel? get currentWave {
    final level = LevelModel.defaults.firstWhere((l) => l.id == _currentLevelId);
    if (_currentWave < level.waves.length) {
      return level.waves[_currentWave];
    }
    return null;
  }

  void advanceWave() {
    _currentWave++;
  }

  bool isLevelComplete() {
    return _currentWave >= _totalWaves;
  }

  int get waveNumber => _currentWave;
  int get totalWaves => _totalWaves;
}
