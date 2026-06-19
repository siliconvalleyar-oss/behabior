import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/data/repositories/save_repository.dart';

class LevelRepository {
  final SaveRepository _saveRepo;
  final List<LevelModel> _levels = [];
  bool _initialized = false;

  LevelRepository(this._saveRepo);

  Future<void> init() async {
    if (_initialized) return;
    _initializeDefaults();
    await _loadProgress();
    _initialized = true;
  }

  void _initializeDefaults() {
    _levels.addAll([
      const LevelModel(
        id: 1,
        name: 'The Awakening',
        description: 'Learn the basics of combat',
        waves: 3,
        isUnlocked: true,
        backgroundAsset: 'backgrounds/level_1',
        waveConfigs: [
          WaveModel(waveNumber: 1, enemyCount: 3, enemyType: 'basic'),
          WaveModel(waveNumber: 2, enemyCount: 5, enemyType: 'basic'),
          WaveModel(waveNumber: 3, enemyCount: 4, enemyType: 'basic', hasBoss: true, bossType: 'miniboss'),
        ],
      ),
      const LevelModel(
        id: 2,
        name: 'First Blood',
        description: 'Fast enemies approaching',
        waves: 4,
        backgroundAsset: 'backgrounds/level_2',
        waveConfigs: [
          WaveModel(waveNumber: 1, enemyCount: 5, enemyType: 'basic'),
          WaveModel(waveNumber: 2, enemyCount: 4, enemyType: 'fast'),
          WaveModel(waveNumber: 3, enemyCount: 6, enemyType: 'fast'),
          WaveModel(waveNumber: 4, enemyCount: 5, enemyType: 'tank', hasBoss: true, bossType: 'tank_boss'),
        ],
      ),
      const LevelModel(
        id: 3,
        name: 'Ranged Threat',
        description: 'Enemies with ranged attacks',
        waves: 5,
        backgroundAsset: 'backgrounds/level_3',
        waveConfigs: [
          WaveModel(waveNumber: 1, enemyCount: 4, enemyType: 'basic'),
          WaveModel(waveNumber: 2, enemyCount: 3, enemyType: 'ranged'),
          WaveModel(waveNumber: 3, enemyCount: 5, enemyType: 'ranged'),
          WaveModel(waveNumber: 4, enemyCount: 4, enemyType: 'tank'),
          WaveModel(waveNumber: 5, enemyCount: 3, enemyType: 'ranged', hasBoss: true, bossType: 'ranged_boss'),
        ],
      ),
      const LevelModel(
        id: 4,
        name: 'Glass Fortress',
        description: 'Defend against all types',
        waves: 5,
        difficultyMultiplier: 1.5,
        backgroundAsset: 'backgrounds/level_4',
        waveConfigs: [
          WaveModel(waveNumber: 1, enemyCount: 6, enemyType: 'basic'),
          WaveModel(waveNumber: 2, enemyCount: 5, enemyType: 'fast'),
          WaveModel(waveNumber: 3, enemyCount: 4, enemyType: 'tank'),
          WaveModel(waveNumber: 4, enemyCount: 5, enemyType: 'ranged'),
          WaveModel(waveNumber: 5, enemyCount: 6, enemyType: 'explosive', hasBoss: true, bossType: 'boss'),
        ],
      ),
      const LevelModel(
        id: 5,
        name: 'The Final Stand',
        description: 'The ultimate challenge',
        waves: 8,
        difficultyMultiplier: 2.0,
        backgroundAsset: 'backgrounds/level_5',
        waveConfigs: [
          WaveModel(waveNumber: 1, enemyCount: 8, enemyType: 'fast'),
          WaveModel(waveNumber: 2, enemyCount: 6, enemyType: 'tank'),
          WaveModel(waveNumber: 3, enemyCount: 7, enemyType: 'ranged'),
          WaveModel(waveNumber: 4, enemyCount: 5, enemyType: 'explosive'),
          WaveModel(waveNumber: 5, enemyCount: 10, enemyType: 'basic'),
          WaveModel(waveNumber: 6, enemyCount: 8, enemyType: 'fast'),
          WaveModel(waveNumber: 7, enemyCount: 6, enemyType: 'tank'),
          WaveModel(waveNumber: 8, enemyCount: 5, enemyType: 'explosive', hasBoss: true, bossType: 'final_boss'),
        ],
      ),
    ]);
  }

  Future<void> _loadProgress() async {
    final data = _saveRepo.loadJsonList('levels');
    if (data == null) return;
    for (final d in data) {
      final index = _levels.indexWhere((l) => l.id == d['id']);
      if (index != -1) {
        _levels[index] = LevelModel(
          id: d['id'] as int,
          name: _levels[index].name,
          description: _levels[index].description,
          waves: d['waves'] as int? ?? _levels[index].waves,
          waveConfigs: _levels[index].waveConfigs,
          backgroundAsset: d['backgroundAsset'] as String? ?? _levels[index].backgroundAsset,
          isUnlocked: d['isUnlocked'] as bool? ?? false,
          starRating: d['starRating'] as int? ?? 0,
          difficultyMultiplier: (d['difficultyMultiplier'] as num?)?.toDouble() ??
              _levels[index].difficultyMultiplier,
        );
      }
    }
  }

  Future<void> saveLevelProgress(LevelModel level) async {
    final index = _levels.indexWhere((l) => l.id == level.id);
    if (index != -1) _levels[index] = level;
    final data = _levels.map((l) => {
      'id': l.id,
      'waves': l.waves,
      'backgroundAsset': l.backgroundAsset,
      'isUnlocked': l.isUnlocked,
      'starRating': l.starRating,
      'difficultyMultiplier': l.difficultyMultiplier,
    }).toList();
    await _saveRepo.saveJsonList('levels', data);
  }

  Future<void> unlockNextLevel(int currentLevelId) async {
    final currentIndex = _levels.indexWhere((l) => l.id == currentLevelId);
    if (currentIndex != -1 && currentIndex + 1 < _levels.length) {
      final next = _levels[currentIndex + 1];
      if (!next.isUnlocked) {
        _levels[currentIndex + 1] = next.copyWith(isUnlocked: true);
        await saveLevelProgress(_levels[currentIndex + 1]);
      }
    }
  }

  List<LevelModel> get levels => List.unmodifiable(_levels);

  LevelModel? getLevel(int id) {
    try {
      return _levels.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }
}
