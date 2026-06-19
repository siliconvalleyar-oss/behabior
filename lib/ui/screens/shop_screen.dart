import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final skills = state.skills;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.background, Color(0xFF1A1A2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => state.navigateTo(AppScreen.menu),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'SKILLS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    const Spacer(),
                    // Skill points
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${state.skillPoints}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Info bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: AppTheme.textSecondary, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Level ${state.playerLevel}',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const Spacer(),
                    Text(
                      '${skills.where((s) => s.currentLevel > 0).length}/${skills.length} skills unlocked',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Skill tree
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    final skill = skills[index];
                    return _SkillCard(
                      skill: skill,
                      skillPoints: state.skillPoints,
                      canUpgrade: _canUpgrade(state, skill),
                      onUpgrade: () => state.upgradeSkill(skill.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canUpgrade(GameState state, SkillModel skill) {
    if (skill.isMaxed) return false;
    if (state.skillPoints < skill.nextCost) return false;

    // Check prerequisites
    for (final prereq in skill.prerequisites) {
      final prereqSkill = state.skills.firstWhere(
        (s) => s.id == prereq,
        orElse: () => SkillModel(id: '', name: '', description: '', type: SkillType.passive),
      );
      if (prereqSkill.currentLevel < 1) return false;
    }
    return true;
  }
}

class _SkillCard extends StatelessWidget {
  final SkillModel skill;
  final int skillPoints;
  final bool canUpgrade;
  final VoidCallback onUpgrade;

  const _SkillCard({
    required this.skill,
    required this.skillPoints,
    required this.canUpgrade,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final isMaxed = skill.isMaxed;
    final hasLevels = skill.currentLevel > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: hasLevels
            ? LinearGradient(
                colors: [
                  AppTheme.surface,
                  AppTheme.primary.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppTheme.surface.withOpacity(0.5),
                  AppTheme.surface.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: Border.all(
          color: hasLevels
              ? AppTheme.primary.withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getSkillColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getSkillIcon(),
                color: _getSkillColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        skill.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isMaxed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'MAX',
                            style: TextStyle(
                              color: AppTheme.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    skill.description,
                    style: TextStyle(
                      color: hasLevels
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondary.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  if (!isMaxed) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Effect: +${skill.currentValue.toInt()} (${skill.levelDisplay})',
                      style: const TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Upgrade button
            if (!isMaxed)
              GestureDetector(
                onTap: canUpgrade ? onUpgrade : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: canUpgrade
                        ? AppTheme.primary
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${skill.nextCost}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Level pips
            if (skill.maxLevel > 1)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(skill.maxLevel, (i) {
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      decoration: BoxDecoration(
                        color: i < skill.currentLevel
                            ? AppTheme.primary
                            : Colors.grey.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getSkillColor() {
    switch (skill.type) {
      case SkillType.passive:
        return AppTheme.secondary;
      case SkillType.active:
        return AppTheme.accent;
      case SkillType.ultimate:
        return AppTheme.warning;
    }
  }

  IconData _getSkillIcon() {
    switch (skill.id) {
      case 'health_boost':
        return Icons.favorite;
      case 'speed_boost':
        return Icons.speed;
      case 'damage_boost':
        return Icons.local_fire_department;
      case 'shield':
        return Icons.shield;
      case 'rage':
        return Icons.flash_on;
      case 'nova':
        return Icons.auto_awesome;
      default:
        return Icons.auto_awesome;
    }
  }
}
