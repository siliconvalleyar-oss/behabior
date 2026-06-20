import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/data/models/achievement_model.dart';

class SaveRepository {
  static const _keySkills = 'skills';
  static const _keyLevels = 'levels';
  static const _keyAchievements = 'achievements';
  static const _keySettings = 'settings';
  static const _keyCoins = 'coins';
  static const _keyWavesCompleted = 'waves_completed';
  static const _keyBossesDefeated = 'bosses_defeated';
  static const _keyTotalKills = 'total_kills';

  final SharedPreferences _prefs;

  SaveRepository(this._prefs);

  Map<String, int> loadSkills() {
    final raw = _prefs.getString(_keySkills);
    if (raw == null) return {};
    return Map<String, int>.from(json.decode(raw) as Map);
  }

  Future<void> saveSkills(Map<String, int> skills) async {
    await _prefs.setString(_keySkills, json.encode(skills));
  }

  Map<String, Map<String, dynamic>> loadLevels() {
    final raw = _prefs.getString(_keyLevels);
    if (raw == null) return {};
    return Map<String, Map<String, dynamic>>.from(
      (json.decode(raw) as Map).map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map))),
    );
  }

  Future<void> saveLevels(Map<String, Map<String, dynamic>> levels) async {
    await _prefs.setString(_keyLevels, json.encode(levels));
  }

  Map<String, bool> loadAchievements() {
    final raw = _prefs.getString(_keyAchievements);
    if (raw == null) return {};
    return Map<String, bool>.from(json.decode(raw) as Map);
  }

  Future<void> saveAchievements(Map<String, bool> achievements) async {
    await _prefs.setString(_keyAchievements, json.encode(achievements));
  }

  Map<String, double> loadSettings() {
    final raw = _prefs.getString(_keySettings);
    if (raw == null) return {'musicVolume': 0.5, 'sfxVolume': 0.7};
    return Map<String, double>.from(
      (json.decode(raw) as Map).map((k, v) => MapEntry(k, (v as num).toDouble())),
    );
  }

  Future<void> saveSettings(Map<String, double> settings) async {
    await _prefs.setString(_keySettings, json.encode(settings));
  }

  int loadCoins() => _prefs.getInt(_keyCoins) ?? 0;
  Future<void> saveCoins(int coins) => _prefs.setInt(_keyCoins, coins);

  int loadWavesCompleted() => _prefs.getInt(_keyWavesCompleted) ?? 0;
  Future<void> saveWavesCompleted(int count) => _prefs.setInt(_keyWavesCompleted, count);

  int loadBossesDefeated() => _prefs.getInt(_keyBossesDefeated) ?? 0;
  Future<void> saveBossesDefeated(int count) => _prefs.setInt(_keyBossesDefeated, count);

  int loadTotalKills() => _prefs.getInt(_keyTotalKills) ?? 0;
  Future<void> saveTotalKills(int count) => _prefs.setInt(_keyTotalKills, count);
}
