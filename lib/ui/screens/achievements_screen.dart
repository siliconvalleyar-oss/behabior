import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final achievements = state.achievementRepo.achievements;
    final unlocked = achievements.where((a) => a.isUnlocked).toList();
    final locked = achievements.where((a) => !a.isUnlocked).toList();
    final totalPoints = state.achievementRepo.totalPoints;

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
                      onPressed: () => state.navigateTo(GameScreen.menu),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ACHIEVEMENTS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.warning.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: AppTheme.warning, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '$totalPoints',
                            style: const TextStyle(
                              color: AppTheme.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Stats bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      '${unlocked.length}/${achievements.length} Unlocked',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    if (unlocked.length == achievements.length)
                      const Text(
                        'COMPLETE!',
                        style: TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: achievements.isEmpty
                        ? 0.0
                        : unlocked.length / achievements.length,
                    backgroundColor: AppTheme.surface,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.warning),
                    minHeight: 6,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Achievement list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    if (unlocked.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'UNLOCKED',
                          style: TextStyle(
                            color: AppTheme.success.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      ...unlocked.map((a) => _AchievementCard(achievement: a)),
                      const SizedBox(height: 16),
                    ],
                    if (locked.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'LOCKED',
                          style: TextStyle(
                            color: AppTheme.textSecondary.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      ...locked.map((a) => _AchievementCard(achievement: a)),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? AppTheme.surface
            : AppTheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppTheme.warning.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? AppTheme.warning.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                achievement.isUnlocked
                    ? Icons.emoji_events
                    : Icons.lock_outline,
                color: achievement.isUnlocked
                    ? AppTheme.warning
                    : Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      color: achievement.isUnlocked
                          ? Colors.white
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      color: achievement.isUnlocked
                          ? AppTheme.textSecondary
                          : Colors.grey.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  if (!achievement.isUnlocked) ...[
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: achievement.progressPercent,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.primary,
                        ),
                        minHeight: 3,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Points or progress
            if (achievement.isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: AppTheme.warning, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '${achievement.rewardPoints}',
                      style: const TextStyle(
                        color: AppTheme.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                achievement.progressDisplay,
                style: TextStyle(
                  color: AppTheme.textSecondary.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
