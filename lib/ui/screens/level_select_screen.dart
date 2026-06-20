import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/data/repositories/level_repository.dart';
import 'package:behabior/ui/themes/app_theme.dart';
import 'package:behabior/ui/screens/game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final repo = LevelRepository(state.saveRepository);
    final levels = repo.getLevels();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('SELECT LEVEL'),
        backgroundColor: AppTheme.surfaceColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final level = levels[index];
            final isUnlocked = repo.isLevelUnlocked(level.id, state.totalStars);
            return _LevelCard(
              level: level,
              isUnlocked: isUnlocked,
              onTap: isUnlocked
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(levelId: level.id),
                        ),
                      )
                  : null,
            );
          },
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final LevelModel level;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.level,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppTheme.glassDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUnlocked ? Icons.shield : Icons.lock,
              size: 48,
              color: isUnlocked ? AppTheme.primaryColor : AppTheme.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              level.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? AppTheme.textPrimary : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Level ${level.id}',
              style: TextStyle(
                fontSize: 14,
                color: isUnlocked ? AppTheme.textSecondary : AppTheme.textSecondary.withAlpha(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
