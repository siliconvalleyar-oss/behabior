import 'package:flutter/foundation.dart';
import 'package:behabior/core/engine/spawn_engine.dart';

enum WaveState { waiting, starting, active, completed, allCompleted }

class WaveSystem extends ChangeNotifier {
  final SpawnEngine _spawnEngine;
  WaveState _state = WaveState.waiting;
  int _currentWave = 0;
  int _totalWaves = 0;
  int _enemiesRemaining = 0;

  WaveSystem(this._spawnEngine);

  void start(int totalWaves) {
    _totalWaves = totalWaves;
    _currentWave = 0;
    _state = WaveState.waiting;
    notifyListeners();
  }

  void startNextWave() {
    if (_currentWave >= _totalWaves) {
      _state = WaveState.allCompleted;
      notifyListeners();
      return;
    }
    _currentWave++;
    _state = WaveState.starting;
    notifyListeners();
  }

  void onWaveStarted(int waveNumber) {
    _state = WaveState.active;
    notifyListeners();
  }

  void onWaveCompleted(int waveNumber) {
    _state = WaveState.completed;
    notifyListeners();
  }

  void updateEnemyCount(int count) {
    _enemiesRemaining = count;
  }

  void reset() {
    _state = WaveState.waiting;
    _currentWave = 0;
    _enemiesRemaining = 0;
    notifyListeners();
  }

  WaveState get state => _state;
  int get currentWave => _currentWave;
  int get totalWaves => _totalWaves;
  int get enemiesRemaining => _enemiesRemaining;
  bool get isActive => _state == WaveState.active;
}
