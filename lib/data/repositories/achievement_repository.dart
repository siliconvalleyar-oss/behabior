import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/data/repositories/save_repository.dart';

class AchievementRepository {
  final SaveRepository _saveRepo;
  final List<AchievementModel> _achievements = [];
  bool _initialized = false;

  AchievementRepository(this._saveRepo);

  Future<void> init() async {
    if (_initialized) return;
    _achievements.addAll(AchievementModel.defaults
        .map((a) => a.copyWith()));
    await _loadProgress();
    _initialized = true;
  }

  Future<void> _loadProgress() async {
    final data = _saveRepo.loadJsonList('achievements');
    if (data == null) return;
    for (final d in data) {
      final index = _achievements.indexWhere((a) => a.id == d['id']);
      if (index != -1) {
        _achievements[index] = _achievements[index].copyWith(
          isUnlocked: d['isUnlocked'] as bool? ?? false,
          progress: (d['progress'] as num?)?.toDouble() ?? 0.0,
          unlockedAt: d['unlockedAt'] != null
              ? DateTime.tryParse(d['unlockedAt'] as String)
              : null,
        );
      }
    }
  }

  Future<void> saveProgress() async {
    final data = _achievements.map((a) => {
      'id': a.id,
      'isUnlocked': a.isUnlocked,
      'progress': a.progress,
      'unlockedAt': a.unlockedAt?.toIso8601String(),
    }).toList();
    await _saveRepo.saveJsonList('achievements', data);
  }

  void updateProgress(String id, double amount) {
    final index = _achievements.indexWhere((a) => a.id == id);
    if (index == -1) return;
    final achievement = _achievements[index];
    if (achievement.isUnlocked) return;
    final newProgress = (achievement.progress + amount).clamp(0.0, achievement.target);
    _achievements[index] = achievement.copyWith(progress: newProgress);
    if (_achievements[index].isComplete) {
      _achievements[index] = _achievements[index].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
    }
  }

  bool checkAndUnlock(String id) {
    final achievement = getAchievement(id);
    if (achievement == null || achievement.isUnlocked) return false;
    final updated = achievement.copyWith(
      isUnlocked: true,
      progress: achievement.target,
      unlockedAt: DateTime.now(),
    );
    final index = _achievements.indexWhere((a) => a.id == id);
    _achievements[index] = updated;
    return true;
  }

  List<AchievementModel> get achievements => List.unmodifiable(_achievements);

  List<AchievementModel> get unlocked =>
      _achievements.where((a) => a.isUnlocked).toList();

  List<AchievementModel> get locked =>
      _achievements.where((a) => !a.isUnlocked).toList();

  AchievementModel? getAchievement(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  int get totalPoints =>
      _achievements.where((a) => a.isUnlocked).fold(0, (sum, a) => sum + a.rewardPoints);
}
