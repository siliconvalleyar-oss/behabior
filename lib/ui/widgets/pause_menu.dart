import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onQuit;
  final VoidCallback onRestart;

  const PauseMenu({
    super.key,
    required this.onResume,
    required this.onQuit,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'PAUSED',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Buttons
                  _PauseButton(
                    label: 'RESUME',
                    icon: Icons.play_arrow,
                    onTap: onResume,
                  ),
                  const SizedBox(height: 12),
                  _PauseButton(
                    label: 'RESTART',
                    icon: Icons.refresh,
                    color: AppTheme.warning,
                    onTap: onRestart,
                  ),
                  const SizedBox(height: 12),
                  _PauseButton(
                    label: 'QUIT',
                    icon: Icons.exit_to_app,
                    color: AppTheme.error,
                    onTap: onQuit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PauseButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _PauseButton({
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
        width: 220,
        height: 48,
        decoration: BoxDecoration(
          color: (color ?? AppTheme.primary).withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (color ?? AppTheme.primary).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color ?? AppTheme.primary, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
