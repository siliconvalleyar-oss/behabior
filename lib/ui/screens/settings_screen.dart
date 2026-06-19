import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                      onPressed: () => state.navigateTo(AppScreen.menu),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _SettingsSection(
                      title: 'AUDIO',
                      children: [
                        _VolumeSlider(
                          label: 'Music Volume',
                          icon: Icons.music_note,
                          value: state.musicVolume,
                          onChanged: state.setMusicVolume,
                        ),
                        const SizedBox(height: 16),
                        _VolumeSlider(
                          label: 'SFX Volume',
                          icon: Icons.volume_up,
                          value: state.sfxVolume,
                          onChanged: state.setSfxVolume,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _SettingsSection(
                      title: 'GRAPHICS',
                      children: [
                        _SettingToggle(
                          label: 'Particle Effects',
                          icon: Icons.auto_awesome,
                          value: true,
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: 12),
                        _SettingToggle(
                          label: 'Screen Shake',
                          icon: Icons.blur_on,
                          value: true,
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: 12),
                        _SettingToggle(
                          label: 'Damage Flash',
                          icon: Icons.flash_on,
                          value: true,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _SettingsSection(
                      title: 'GAMEPLAY',
                      children: [
                        _SettingToggle(
                          label: 'Auto-Attack',
                          icon: Icons.gps_fixed,
                          value: false,
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: 12),
                        _SettingToggle(
                          label: 'Vibration',
                          icon: Icons.vibration,
                          value: true,
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Clear data
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _showClearDataDialog(context, state),
                        icon: const Icon(Icons.delete_outline, color: AppTheme.error),
                        label: const Text(
                          'Clear Save Data',
                          style: TextStyle(color: AppTheme.error),
                        ),
                      ),
                    ),
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

  void _showClearDataDialog(BuildContext context, GameState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Clear Data', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will reset all progress, achievements, and settings. This cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              state.saveRepo.clearAll();
              Navigator.pop(ctx);
            },
            child: const Text('Clear', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: AppTheme.secondary.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final ValueChanged<double> onChanged;

  const _VolumeSlider({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
              Slider(
                value: value,
                onChanged: onChanged,
                min: 0.0,
                max: 1.0,
                divisions: 10,
              ),
            ],
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '${(value * 100).toInt()}%',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _SettingToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primary,
        ),
      ],
    );
  }
}
