import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/ui/themes/app_theme.dart';
import 'package:behabior/ui/screens/level_select_screen.dart';
import 'package:behabior/ui/screens/settings_screen.dart';
import 'package:behabior/ui/screens/achievements_screen.dart';
import 'package:behabior/ui/screens/shop_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.backgroundColor, Color(0xFF0D0D15)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                'BEHABIOR',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                  letterSpacing: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PIXEL DEFENDER',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary.withAlpha(150),
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 60),
              _MenuButton(
                label: 'PLAY',
                icon: Icons.play_arrow,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                label: 'SKILLS',
                icon: Icons.auto_awesome,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                label: 'ACHIEVEMENTS',
                icon: Icons.emoji_events,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                label: 'SETTINGS',
                icon: Icons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    Text(
                      '${state.coins} COINS',
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppTheme.starColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Skill Points: ${state.availableSkillPoints}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
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

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          backgroundColor: AppTheme.cardColor,
          foregroundColor: AppTheme.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppTheme.primaryColor.withAlpha(80)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryLight, size: 24),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 18, letterSpacing: 4)),
          ],
        ),
      ),
    );
  }
}
