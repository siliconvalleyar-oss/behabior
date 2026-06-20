import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/data/providers/game_state.dart';

class AchievementSystem {
  final GameState _gameState;
  final List<String> _recentUnlocks = [];

  AchievementSystem(this._gameState);

  void checkKillAchievements(int totalKills) {
    final thresholds = {'kills_100': 100, 'kills_500': 500, 'kills_1000': 1000};
    for (final entry in thresholds.entries) {
      if (totalKills >= entry.value) {
        _unlock(entry.key);
      }
    }
  }

  void checkWaveAchievements(int wavesCompleted) {
    final thresholds = {'waves_25': 25, 'waves_100': 100};
    for (final entry in thresholds.entries) {
      if (wavesCompleted >= entry.value) {
        _unlock(entry.key);
      }
    }
  }

  void checkBossAchievements(int bossesDefeated) {
    if (bossesDefeated >= 10) {
      _unlock('bosses_10');
    }
    if (bossesDefeated >= 1) {
      _unlock('first_kill');
    }
  }

  void checkSkillAchievement() {
    if (_gameState.allSkillsMaxed()) {
      _unlock('all_skills');
    }
  }

  void _unlock(String id) {
    if (!_hasAchievement(id)) {
      _recentUnlocks.add(id);
    }
  }

  bool _hasAchievement(String id) {
    return _gameState.achievements.any((a) => a.id == id && a.isUnlocked);
  }

  List<String> consumeRecentUnlocks() {
    final copy = List<String>.from(_recentUnlocks);
    _recentUnlocks.clear();
    return copy;
  }
}
