import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SaveRepository {
  static const String _prefix = 'behabior_';
  static const String _levelKey = '${_prefix}levels';
  static const String _achievementsKey = '${_prefix}achievements';
  static const String _skillsKey = '${_prefix}skills';
  static const String _settingsKey = '${_prefix}settings';
  static const String _playerKey = '${_prefix}player';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic save/load
  Future<bool> save(String key, String value) async {
    if (_prefs == null) await init();
    return _prefs!.setString(_prefix + key, value);
  }

  String? load(String key) {
    return _prefs?.getString(_prefix + key);
  }

  // JSON helpers
  Future<void> saveJson(String key, Map<String, dynamic> data) async {
    await save(key, jsonEncode(data));
  }

  Map<String, dynamic>? loadJson(String key) {
    final data = load(key);
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> saveJsonList(String key, List<Map<String, dynamic>> data) async {
    await save(key, jsonEncode(data));
  }

  List<Map<String, dynamic>>? loadJsonList(String key) {
    final data = load(key);
    if (data == null) return null;
    return (jsonDecode(data) as List).cast<Map<String, dynamic>>();
  }

  // Specific helpers
  Future<void> saveDouble(String key, double value) async {
    if (_prefs == null) await init();
    await _prefs!.setDouble(_prefix + key, value);
  }

  double? loadDouble(String key) {
    return _prefs?.getDouble(_prefix + key);
  }

  Future<void> saveInt(String key, int value) async {
    if (_prefs == null) await init();
    await _prefs!.setInt(_prefix + key, value);
  }

  int? loadInt(String key) {
    return _prefs?.getInt(_prefix + key);
  }

  Future<void> saveBool(String key, bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_prefix + key, value);
  }

  bool? loadBool(String key) {
    return _prefs?.getBool(_prefix + key);
  }

  Future<void> clearAll() async {
    if (_prefs == null) await init();
    final keys = _prefs!.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      await _prefs!.remove(key);
    }
  }
}
