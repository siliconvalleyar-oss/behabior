import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class GameOverOverlay extends StatelessWidget {
  final bool isVictory;
  final int score;
  final int kills;
  final int wavesCompleted;
  final VoidCallback onRetry;
  final VoidCallback onMenu;

  const GameOverOverlay({
    super.key,
    required this.isVictory,
    required this.score,
    required this.kills,
    required this.wavesCompleted,
    required this.onRetry,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: isVictory
                            ? const LinearGradient(
                                colors: [AppTheme.success, Color(0xFF00B894)],
                              )
                            : const LinearGradient(
                                colors: [AppTheme.error, Color(0xFFD63031)],
                              ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (isVictory ? AppTheme.success : AppTheme.error)
                                .withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        isVictory ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      isVictory ? 'VICTORY!' : 'DEFEATED',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: isVictory ? AppTheme.success : AppTheme.error,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isVictory
                          ? 'All waves cleared!'
                          : 'You have fallen in battle',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          _StatRow(
                            label: 'Score',
                            value: '$score',
                            icon: Icons.monetization_on,
                            color: AppTheme.warning,
                          ),
                          const Divider(color: Colors.white10, height: 20),
                          _StatRow(
                            label: 'Kills',
                            value: '$kills',
                            icon: Icons.dangerous,
                            color: AppTheme.error,
                          ),
                          const Divider(color: Colors.white10, height: 20),
                          _StatRow(
                            label: 'Waves',
                            value: '$wavesCompleted',
                            icon: Icons.waves,
                            color: AppTheme.secondary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ActionButton(
                          label: 'RETRY',
                          icon: Icons.refresh,
                          onTap: onRetry,
                        ),
                        const SizedBox(width: 16),
                        _ActionButton(
                          label: 'MENU',
                          icon: Icons.home,
                          color: AppTheme.textSecondary,
                          onTap: onMenu,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: (color ?? AppTheme.primary).withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (color ?? AppTheme.primary).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color ?? Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
