import 'package:behabior/data/repositories/achievement_repository.dart';
import 'package:flutter/foundation.dart';

class AchievementSystem extends ChangeNotifier {
  final AchievementRepository _repository;
  String? _lastUnlockedAchievement;
  bool _showPopup = false;

  AchievementSystem(this._repository);

  void onEnemyKilled() {
    _repository.updateProgress('first_kill', 1.0);
    _repository.updateProgress('enemy_100', 1.0);
    _checkUnlock('first_kill');
    _checkUnlock('enemy_100');
  }

  void onWaveCompleted(int wave) {
    _repository.updateProgress('wave_5', 1.0);
    if (wave == 5) _checkUnlock('wave_5');
  }

  void onBossKilled() {
    _checkUnlock('boss_kill');
  }

  void onPlayerLevelUp(int level) {
    _repository.updateProgress('level_5', 1.0);
    _checkUnlock('level_5');
  }

  void onSkillUnlocked() {
    _checkUnlock('skill_master');
  }

  void onGlassBroken() {
    _repository.updateProgress('glass_walker', 1.0);
    _checkUnlock('glass_walker');
  }

  void onPerfectWave() {
    _checkUnlock('perfect_wave');
  }

  void _checkUnlock(String id) {
    final achievement = _repository.getAchievement(id);
    if (achievement == null || achievement.isUnlocked) return;
    if (achievement.isComplete) {
      if (_repository.checkAndUnlock(id)) {
        _lastUnlockedAchievement = id;
        _showPopup = true;
        notifyListeners();
        Future.delayed(const Duration(seconds: 3), () {
          _showPopup = false;
          notifyListeners();
        });
      }
    }
  }

  String? get lastUnlocked => _lastUnlockedAchievement;
  bool get showUnlockPopup => _showPopup;
  AchievementRepository get repository => _repository;
}
