import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

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
                      'SELECT LEVEL',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                    const Spacer(),
                    // Player info
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person, size: 16, color: AppTheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            'Lv.${state.playerLevel}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Level grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.levelRepo.levels.length,
                  itemBuilder: (context, index) {
                    final level = state.levelRepo.levels[index];
                    return _LevelCard(
                      level: level,
                      onTap: level.isUnlocked
                          ? () => state.startLevel(level.id)
                          : null,
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
}

class _LevelCard extends StatelessWidget {
  final LevelModel level;
  final VoidCallback? onTap;

  const _LevelCard({required this.level, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: level.isUnlocked
              ? LinearGradient(
                  colors: [
                    AppTheme.surface,
                    AppTheme.primary.withOpacity(0.3),
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
          border: level.isUnlocked
              ? Border.all(color: AppTheme.primary.withOpacity(0.3))
              : null,
          boxShadow: level.isUnlocked
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Level number and lock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: level.isUnlocked
                          ? AppTheme.primary
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${level.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  if (!level.isUnlocked)
                    const Icon(Icons.lock, color: Colors.grey, size: 18),
                ],
              ),

              // Level info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.name,
                    style: TextStyle(
                      color: level.isUnlocked ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level.description,
                    style: TextStyle(
                      color: level.isUnlocked
                          ? AppTheme.textSecondary
                          : Colors.grey.withOpacity(0.5),
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              // Stars
              Row(
                children: List.generate(3, (i) {
                  return Icon(
                    i < level.starRating
                        ? Icons.star
                        : Icons.star_border,
                    color: AppTheme.warning,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
