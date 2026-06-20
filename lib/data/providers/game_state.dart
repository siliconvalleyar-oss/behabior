import 'package:flutter/foundation.dart';
import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/data/repositories/save_repository.dart';

class GameState extends ChangeNotifier {
  final SaveRepository saveRepository;
  final List<SkillModel> skills;
  final List<AchievementModel> achievements;
  int coins;
  int totalKills;
  int wavesCompleted;
  int bossesDefeated;
  int totalStars;
  int currentLevelId;
  double musicVolume;
  double sfxVolume;
  int availableSkillPoints;
  bool gameStarted;

  GameState({
    required this.saveRepository,
    required this.skills,
    required this.achievements,
    this.coins = 0,
    this.totalKills = 0,
    this.wavesCompleted = 0,
    this.bossesDefeated = 0,
    this.totalStars = 0,
    this.currentLevelId = 1,
    this.musicVolume = 0.5,
    this.sfxVolume = 0.7,
    this.availableSkillPoints = 0,
    this.gameStarted = false,
  });

  int get experience => totalKills * 10;

  bool canAfford(int cost) => coins >= cost;

  void spendCoins(int amount) {
    if (coins >= amount) {
      coins -= amount;
      notifyListeners();
    }
  }

  void addKill() {
    totalKills++;
    coins += 2;
    notifyListeners();
  }

  void addCoins(int amount) {
    coins += amount;
    notifyListeners();
  }

  void completeLevel(int levelId, int stars) {
    totalStars += stars;
    availableSkillPoints += stars;
    notifyListeners();
  }

  bool isSkillUnlocked(SkillModel skill) {
    if (skill.prerequisites.isEmpty) return true;
    for (final prereqId in skill.prerequisites) {
      final prereq = skills.where((s) => s.id == prereqId).firstOrNull;
      if (prereq == null || prereq.currentLevel < 1) return false;
    }
    return true;
  }

  SkillModel? getSkill(String id) {
    return skills.where((s) => s.id == id).firstOrNull;
  }

  void upgradeSkill(String id) {
    final idx = skills.indexWhere((s) => s.id == id);
    if (idx < 0) return;
    final skill = skills[idx];
    if (!canUpgradeSkill(skill)) return;
    availableSkillPoints -= skill.costPerLevel;
    skills[idx] = skill.upgrade();
    notifyListeners();
  }

  void updateSkillLevel(String id, int level) {
    final idx = skills.indexWhere((s) => s.id == id);
    if (idx >= 0) {
      skills[idx] = skills[idx].copyWith(currentLevel: level);
      notifyListeners();
    }
  }

  bool allSkillsMaxed() {
    return skills.every((s) => s.currentLevel >= s.maxLevel);
  }

  bool canUpgradeSkill(SkillModel skill) {
    return skill.currentLevel < skill.maxLevel &&
        availableSkillPoints >= skill.costPerLevel &&
        isSkillUnlocked(skill);
  }

  Map<String, double> getSkillBonuses() {
    final bonuses = <String, double>{
      'maxHealth': 0,
      'speed': 0,
      'damage': 0,
      'shieldDuration': 0,
      'attackSpeed': 0,
      'novaDamage': 0,
    };
    for (final skill in skills) {
      final value = skill.currentValue;
      final level = skill.currentLevel;
      switch (skill.id) {
        case 'health_boost':
          bonuses['maxHealth'] = bonuses['maxHealth']! + value;
        case 'speed_boost':
          bonuses['speed'] = bonuses['speed']! + value;
        case 'damage_boost':
          bonuses['damage'] = bonuses['damage']! + value;
        case 'shield':
          bonuses['shieldDuration'] = value;
        case 'rage':
          bonuses['attackSpeed'] = value;
        case 'nova':
          bonuses['novaDamage'] = value;
      }
    }
    return bonuses;
  }

  int get skillPoints => availableSkillPoints;
}
