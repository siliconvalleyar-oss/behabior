import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/data/repositories/save_repository.dart';

class AchievementRepository {
  final SaveRepository _saveRepo;

  AchievementRepository(this._saveRepo);

  List<AchievementModel> loadAchievements() {
    final unlocked = _saveRepo.loadAchievements();
    return AchievementModel.defaults.map((a) {
      final isUnlocked = unlocked[a.id] ?? false;
      return a.copyWith(isUnlocked: isUnlocked, currentProgress: isUnlocked ? 1 : 0);
    }).toList();
  }

  Future<void> unlockAchievement(String id) async {
    final data = _saveRepo.loadAchievements();
    data[id] = true;
    await _saveRepo.saveAchievements(data);
  }

  bool isUnlocked(String id) {
    final data = _saveRepo.loadAchievements();
    return data[id] ?? false;
  }
}
