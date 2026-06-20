import 'package:flutter/foundation.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/data/providers/game_state.dart';

class SkillSystem extends ChangeNotifier {
  final GameState _gameState;
  String? _lastActivatedSkill;

  SkillSystem(this._gameState);

  bool canUnlock(String skillId) {
    final skill = _gameState.skills.firstWhere(
      (s) => s.id == skillId,
      orElse: () => SkillModel(id: '', name: '', description: '', type: SkillType.passive),
    );
    if (skill.id.isEmpty || skill.isMaxed) return false;
    if (_gameState.skillPoints < skill.nextCost) return false;

    // Check prerequisites
    for (final prereq in skill.prerequisites) {
      final prereqSkill = _gameState.skills.firstWhere(
        (s) => s.id == prereq,
        orElse: () => SkillModel(id: '', name: '', description: '', type: SkillType.passive),
      );
      if (prereqSkill.currentLevel < 1) return false;
    }
    return true;
  }

  bool unlockSkill(String skillId) {
    if (!canUnlock(skillId)) return false;
    _gameState.upgradeSkill(skillId);
    _lastActivatedSkill = skillId;
    notifyListeners();
    return true;
  }

  // Get computed stat bonuses
  double get healthBonus {
    final skill = _getSkill('health_boost');
    return skill?.currentValue ?? 0;
  }

  double get speedBonus {
    final skill = _getSkill('speed_boost');
    return skill?.currentValue ?? 0;
  }

  double get damageBonus {
    final skill = _getSkill('damage_boost');
    return skill?.currentValue ?? 0;
  }

  double get shieldDuration {
    final skill = _getSkill('shield');
    return skill?.currentValue ?? 0;
  }

  double get rageMultiplier {
    final skill = _getSkill('rage');
    return skill?.currentValue ?? 1.0;
  }

  double get novaDamage {
    final skill = _getSkill('nova');
    return skill?.currentValue ?? 0;
  }

  SkillModel? _getSkill(String id) {
    try {
      return _gameState.skills.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  bool get hasShield => shieldDuration > 0;
  bool get hasRage => rageMultiplier > 1.0;
  bool get hasNova => novaDamage > 0;

  String? get lastActivatedSkill => _lastActivatedSkill;
}
