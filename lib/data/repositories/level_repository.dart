import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/data/repositories/save_repository.dart';

class LevelRepository {
  final SaveRepository _saveRepo;

  LevelRepository(this._saveRepo);

  List<LevelModel> getLevels() => LevelModel.defaults;

  LevelModel getLevel(int id) {
    return LevelModel.defaults.firstWhere((l) => l.id == id);
  }

  bool isLevelUnlocked(int levelId, int totalStars) {
    final level = getLevel(levelId);
    return totalStars >= level.starRequirement;
  }

  Map<String, Map<String, dynamic>> loadProgress() => _saveRepo.loadLevels();

  Future<void> saveProgress(int levelId, int stars, bool completed) async {
    final data = _saveRepo.loadLevels();
    data[levelId.toString()] = {'stars': stars, 'completed': completed};
    await _saveRepo.saveLevels(data);
  }
}
