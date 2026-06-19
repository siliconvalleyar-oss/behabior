import 'package:flutter/foundation.dart';

class ScoreSystem extends ChangeNotifier {
  int _score = 0;
  int _highScore = 0;
  int _combo = 0;
  double _comboTimer = 0.0;
  static const double comboDuration = 3.0;
  int _kills = 0;
  int _headshots = 0;

  void addKill(double enemyHealth) {
    _kills++;
    _combo++;
    _comboTimer = comboDuration;
    final basePoints = (enemyHealth * 2).toInt();
    final comboMultiplier = 1.0 + (_combo * 0.1);
    _score += (basePoints * comboMultiplier).toInt();
    notifyListeners();
  }

  void addHeadshot() {
    _headshots++;
    _score += 50;
    notifyListeners();
  }

  void addBossKill(double bossHealth) {
    _score += (bossHealth * 3).toInt();
    notifyListeners();
  }

  void addTimeBonus(double timeRemaining) {
    _score += (timeRemaining * 10).toInt();
    notifyListeners();
  }

  void update(double dt) {
    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) {
        _combo = 0;
        notifyListeners();
      }
    }
  }

  void reset() {
    if (_score > _highScore) {
      _highScore = _score;
    }
    _score = 0;
    _combo = 0;
    _comboTimer = 0.0;
    _kills = 0;
    _headshots = 0;
    notifyListeners();
  }

  int get score => _score;
  int get highScore => _highScore;
  int get combo => _combo;
  double get comboProgress => _comboTimer / comboDuration;
  int get kills => _kills;
  int get headshots => _headshots;
}
