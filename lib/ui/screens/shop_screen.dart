import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('SKILL TREE'),
        backgroundColor: AppTheme.surfaceColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Pts: ${state.availableSkillPoints}',
                style: const TextStyle(
                  color: AppTheme.starColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: state.skills.length,
          itemBuilder: (context, index) {
            final skill = state.skills[index];
            return _SkillCard(
              skill: skill,
              canAfford: state.canUpgradeSkill(skill),
              canUnlock: state.isSkillUnlocked(skill),
              onUpgrade: () {
                state.upgradeSkill(skill.id);
              },
            );
          },
        ),
      ),
    );
  }
}

class _SkillCard extends StatelessWidget {
  final SkillModel skill;
  final bool canAfford;
  final bool canUnlock;
  final VoidCallback onUpgrade;

  const _SkillCard({
    required this.skill,
    required this.canAfford,
    required this.canUnlock,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final isMaxed = skill.currentLevel >= skill.maxLevel;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isMaxed
                  ? AppTheme.starColor.withAlpha(50)
                  : canUnlock
                      ? AppTheme.primaryColor.withAlpha(50)
                      : AppTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.auto_awesome,
              color: isMaxed ? AppTheme.starColor : canUnlock ? AppTheme.primaryLight : AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isMaxed ? AppTheme.starColor : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  skill.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Lv ${skill.currentLevel}/${skill.maxLevel}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                    if (skill.prerequisites.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Req: ${skill.prerequisites.join(", ")}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!isMaxed)
            ElevatedButton(
              onPressed: canAfford ? onUpgrade : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: canAfford ? AppTheme.primaryColor : AppTheme.cardColor,
              ),
              child: Text(
                '${skill.costPerLevel}pt',
                style: TextStyle(
                  fontSize: 12,
                  color: canAfford ? AppTheme.textPrimary : AppTheme.textSecondary,
                ),
              ),
            )
          else
            const Icon(Icons.check_circle, color: AppTheme.starColor),
        ],
      ),
    );
  }
}
