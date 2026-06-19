import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class HUD extends StatelessWidget {
  final int score;
  final double health;
  final double maxHealth;
  final int waveNumber;
  final int totalWaves;
  final int combo;
  final int kills;
  final VoidCallback onPause;

  const HUD({
    super.key,
    required this.score,
    required this.health,
    required this.maxHealth,
    required this.waveNumber,
    required this.totalWaves,
    this.combo = 0,
    this.kills = 0,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              // Top row
              Row(
                children: [
                  // Score
                  const Icon(Icons.monetization_on, color: AppTheme.warning, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '$score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Wave
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Wave $waveNumber/$totalWaves',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Kills
                  if (kills > 0) ...[
                    const Icon(Icons.dangerous, color: AppTheme.error, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '$kills',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // Pause button
                  GestureDetector(
                    onTap: onPause,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Health bar
              Row(
                children: [
                  const Icon(Icons.favorite, color: AppTheme.error, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: maxHealth > 0 ? (health / maxHealth).clamp(0.0, 1.0) : 0.0,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          health / maxHealth > 0.5
                              ? AppTheme.success
                              : health / maxHealth > 0.25
                                  ? AppTheme.warning
                                  : AppTheme.error,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${health.toInt()}/${maxHealth.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Combo
              if (combo > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$combo COMBO!',
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          shadows: [
                            Shadow(
                              color: AppTheme.accent.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
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
