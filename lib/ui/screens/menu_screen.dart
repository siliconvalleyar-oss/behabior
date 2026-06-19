import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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
          child: Stack(
            children: [
              // Background particles (static decorative)
              ...List.generate(20, (i) => Positioned(
                left: (i * 37.0) % MediaQuery.of(context).size.width,
                top: (i * 53.0) % MediaQuery.of(context).size.height,
                child: Container(
                  width: 2 + (i % 4).toDouble(),
                  height: 2 + (i % 4).toDouble(),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.1 + (i % 3) * 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              )),

              // Title
              FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // Game icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'BEHABIOR',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PIXEL DEFENDER',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.secondary.withOpacity(0.8),
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Menu buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            _MenuButton(
                              label: 'PLAY',
                              icon: Icons.play_arrow_rounded,
                              gradient: AppTheme.primaryGradient,
                              onTap: () => state.navigateTo(GameScreen.levelSelect),
                            ),
                            const SizedBox(height: 12),
                            _MenuButton(
                              label: 'ACHIEVEMENTS',
                              icon: Icons.emoji_events_outlined,
                              color: AppTheme.warning,
                              onTap: () => state.navigateTo(GameScreen.achievements),
                            ),
                            const SizedBox(height: 12),
                            _MenuButton(
                              label: 'SKILLS',
                              icon: Icons.auto_awesome,
                              color: AppTheme.accent,
                              onTap: () => state.navigateTo(GameScreen.shop),
                            ),
                            const SizedBox(height: 12),
                            _MenuButton(
                              label: 'SETTINGS',
                              icon: Icons.settings_outlined,
                              color: AppTheme.textSecondary,
                              onTap: () => state.navigateTo(GameScreen.settings),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 1),

                      // Version
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'v1.0.0',
                          style: TextStyle(
                            color: AppTheme.textSecondary.withOpacity(0.3),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
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
  final Gradient? gradient;
  final Color? color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.icon,
    this.gradient,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: gradient,
        color: color,
        boxShadow: [
          BoxShadow(
            color: (gradient != null ? Colors.purple : color ?? Colors.grey)
                .withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
