import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('ACHIEVEMENTS'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.achievements.length,
        itemBuilder: (context, index) {
          final achievement = state.achievements[index];
          return _AchievementCard(achievement: achievement);
        },
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementModel achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(
        color: achievement.isUnlocked
            ? AppTheme.starColor.withAlpha(20)
            : AppTheme.cardColor,
      ),
      child: Row(
        children: [
          Icon(
            achievement.isUnlocked ? Icons.emoji_events : Icons.lock_outline,
            size: 36,
            color: achievement.isUnlocked ? AppTheme.starColor : AppTheme.textSecondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: achievement.isUnlocked ? AppTheme.starColor : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (!achievement.isUnlocked) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: achievement.progressFraction,
                      backgroundColor: AppTheme.cardColor,
                      valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (achievement.isUnlocked)
            const Icon(Icons.check_circle, color: AppTheme.successColor),
        ],
      ),
    );
  }
}
