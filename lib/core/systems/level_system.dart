import 'package:flutter/foundation.dart';
import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/data/repositories/level_repository.dart';
import 'package:behabior/data/providers/game_state.dart';

class LevelSystem extends ChangeNotifier {
  final LevelRepository _repository;
  final GameState _gameState;
  int _currentLevelId = 1;
  bool _isPlaying = false;

  LevelSystem(this._repository, this._gameState);

  void startLevel(int levelId) {
    _currentLevelId = levelId;
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> completeLevel(int stars) async {
    _isPlaying = false;
    final level = _repository.getLevel(_currentLevelId);
    if (level != null) {
      final updated = level.copyWith(
        starRating: stars > level.starRating ? stars : level.starRating,
      );
      await _repository.saveLevelProgress(updated);
      await _repository.unlockNextLevel(_currentLevelId);
    }
    notifyListeners();
  }

  void failLevel() {
    _isPlaying = false;
    notifyListeners();
  }

  void returnToMenu() {
    _isPlaying = false;
    notifyListeners();
  }

  List<LevelModel> get levels => _repository.levels;

  LevelModel? get currentLevel => _repository.getLevel(_currentLevelId);

  LevelModel? getLevel(int id) => _repository.getLevel(id);

  bool get isPlaying => _isPlaying;
  int get currentLevelId => _currentLevelId;
}
