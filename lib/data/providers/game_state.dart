import 'package:flutter/foundation.dart';
import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/data/repositories/save_repository.dart';
import 'package:behabior/data/repositories/level_repository.dart';
import 'package:behabior/data/repositories/achievement_repository.dart';
import 'package:behabior/core/config/game_config.dart';

enum GameScreen { menu, playing, paused, levelSelect, settings, achievements, shop, gameOver }

class GameState extends ChangeNotifier {
  final SaveRepository saveRepo;
  final LevelRepository levelRepo;
  final AchievementRepository achievementRepo;

  GameScreen _currentScreen = GameScreen.menu;
  int _currentLevelId = 1;
  int _playerLevel = 1;
  int _playerXp = 0;
  int _totalKills = 0;
  int _score = 0;
  double _musicVolume = GameConfig.defaultMusicVolume;
  double _sfxVolume = GameConfig.defaultSfxVolume;
  int _skillPoints = 0;
  final List<SkillModel> _skills = [];
  bool _initialized = false;

  GameState({
    required this.saveRepo,
    required this.levelRepo,
    required this.achievementRepo,
  });

  Future<void> init() async {
    if (_initialized) return;
    await saveRepo.init();
    await levelRepo.init();
    await achievementRepo.init();
    _loadSettings();
    _initializeSkills();
    _loadSkills();
    _loadPlayerData();
    _initialized = true;
    notifyListeners();
  }

  void _initializeSkills() {
    _skills.addAll(SkillModel.defaults.map((s) => s.copyWith()));
  }

  void _loadSettings() {
    _musicVolume = saveRepo.loadDouble('music_volume') ?? GameConfig.defaultMusicVolume;
    _sfxVolume = saveRepo.loadDouble('sfx_volume') ?? GameConfig.defaultSfxVolume;
  }

  void _loadSkills() {
    final data = saveRepo.loadJsonList('skills');
    if (data == null) return;
    for (final d in data) {
      final index = _skills.indexWhere((s) => s.id == d['id']);
      if (index != -1) {
        _skills[index] = _skills[index].copyWith(
          currentLevel: d['currentLevel'] as int? ?? 0,
          isUnlocked: d['isUnlocked'] as bool? ?? true,
        );
      }
    }
  }

  void _loadPlayerData() {
    _playerLevel = saveRepo.loadInt('player_level') ?? 1;
    _playerXp = saveRepo.loadInt('player_xp') ?? 0;
    _totalKills = saveRepo.loadInt('total_kills') ?? 0;
    _skillPoints = saveRepo.loadInt('skill_points') ?? 0;
  }

  Future<void> _savePlayerData() async {
    await saveRepo.saveInt('player_level', _playerLevel);
    await saveRepo.saveInt('player_xp', _playerXp);
    await saveRepo.saveInt('total_kills', _totalKills);
    await saveRepo.saveInt('skill_points', _skillPoints);
  }

  Future<void> saveSettings() async {
    await saveRepo.saveDouble('music_volume', _musicVolume);
    await saveRepo.saveDouble('sfx_volume', _sfxVolume);
  }

  // Screen navigation
  void navigateTo(GameScreen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  // Level management
  void startLevel(int levelId) {
    _currentLevelId = levelId;
    _score = 0;
    _currentScreen = GameScreen.playing;
    notifyListeners();
  }

  Future<void> completeLevel(int levelId, int stars) async {
    final level = levelRepo.getLevel(levelId);
    if (level != null) {
      final updated = level.copyWith(
        starRating: stars > level.starRating ? stars : level.starRating,
      );
      await levelRepo.saveLevelProgress(updated);
      await levelRepo.unlockNextLevel(levelId);
    }
    _currentScreen = GameScreen.levelSelect;
    notifyListeners();
  }

  void gameOver() {
    _currentScreen = GameScreen.gameOver;
    notifyListeners();
  }

  // XP & Leveling
  void addXp(int amount) {
    _playerXp += amount;
    while (_playerXp >= xpForNextLevel) {
      _playerXp -= xpForNextLevel;
      _playerLevel++;
      _skillPoints += GameConfig.skillPointsPerLevel;
      achievementRepo.checkAndUnlock('level_5');
    }
    _savePlayerData();
    notifyListeners();
  }

  int get xpForNextLevel => _playerLevel * 100;

  void addKill() {
    _totalKills++;
    _savePlayerData();
  }

  // Score
  void addScore(int points) {
    _score += points;
  }

  // Skills
  bool upgradeSkill(String skillId) {
    final index = _skills.indexWhere((s) => s.id == skillId);
    if (index == -1) return false;
    final skill = _skills[index];
    if (skill.isMaxed || _skillPoints < skill.nextCost) return false;
    _skillPoints -= skill.nextCost;
    _skills[index] = skill.upgrade();
    achievementRepo.checkAndUnlock('skill_master');
    _saveSkills();
    _savePlayerData();
    notifyListeners();
    return true;
  }

  Future<void> _saveSkills() async {
    final data = _skills.map((s) => {
      'id': s.id,
      'currentLevel': s.currentLevel,
      'isUnlocked': s.isUnlocked,
    }).toList();
    await saveRepo.saveJsonList('skills', data);
  }

  // Volume
  void setMusicVolume(double vol) {
    _musicVolume = vol.clamp(0.0, 1.0);
    saveSettings();
    notifyListeners();
  }

  void setSfxVolume(double vol) {
    _sfxVolume = vol.clamp(0.0, 1.0);
    saveSettings();
    notifyListeners();
  }

  // Getters
  GameScreen get currentScreen => _currentScreen;
  int get currentLevelId => _currentLevelId;
  int get playerLevel => _playerLevel;
  int get playerXp => _playerXp;
  int get totalKills => _totalKills;
  int get score => _score;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  int get skillPoints => _skillPoints;
  List<SkillModel> get skills => List.unmodifiable(_skills);
  bool get isInitialized => _initialized;

  LevelModel? get currentLevel => levelRepo.getLevel(_currentLevelId);
}
