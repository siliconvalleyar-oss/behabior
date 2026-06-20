import 'package:behabior/core/entities/base_entity.dart';

class ScoreSystem {
  int score = 0;
  int combo = 0;
  double _comboTimer = 0;
  static const double _comboTimeout = 2.0;
  static const double _comboMultiplier = 0.1;

  void addKill(BaseEntity entity) {
    combo++;
    _comboTimer = _comboTimeout;
    final base = 10;
    final multiplier = 1.0 + combo * _comboMultiplier;
    score += (base * multiplier).round();
  }

  void addBossKill(BaseEntity entity) {
    combo++;
    score += 200;
  }

  void addTimeBonus() {
    score += 50;
  }

  void update(double dt) {
    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) {
        combo = 0;
        _comboTimer = 0;
      }
    }
  }

  void reset() {
    score = 0;
    combo = 0;
    _comboTimer = 0;
  }
}
