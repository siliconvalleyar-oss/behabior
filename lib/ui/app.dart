import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/models/skill_model.dart';
import 'package:behabior/data/models/achievement_model.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/data/repositories/save_repository.dart';
import 'package:behabior/ui/themes/app_theme.dart';
import 'package:behabior/ui/screens/menu_screen.dart';

class BehabiorApp extends StatefulWidget {
  final SaveRepository saveRepository;

  const BehabiorApp({super.key, required this.saveRepository});

  @override
  State<BehabiorApp> createState() => _BehabiorAppState();
}

class _BehabiorAppState extends State<BehabiorApp> {
  late final GameState _gameState;

  @override
  void initState() {
    super.initState();
    final savedSkills = widget.saveRepository.loadSkills();
    final settings = widget.saveRepository.loadSettings();

    final skills = SkillModel.defaults.map((s) {
      final level = savedSkills[s.id] ?? 0;
      return s.copyWith(currentLevel: level);
    }).toList();

    final achievements = AchievementModel.defaults.map((a) {
      final data = widget.saveRepository.loadAchievements();
      final isUnlocked = data[a.id] ?? false;
      return a.copyWith(isUnlocked: isUnlocked, currentProgress: isUnlocked ? 1 : 0);
    }).toList();

    _gameState = GameState(
      saveRepository: widget.saveRepository,
      skills: skills,
      achievements: achievements,
      coins: widget.saveRepository.loadCoins(),
      totalKills: widget.saveRepository.loadTotalKills(),
      wavesCompleted: widget.saveRepository.loadWavesCompleted(),
      bossesDefeated: widget.saveRepository.loadBossesDefeated(),
      musicVolume: settings['musicVolume'] ?? 0.5,
      sfxVolume: settings['sfxVolume'] ?? 0.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameState,
      child: MaterialApp(
        title: 'Behabior',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const MenuScreen(),
      ),
    );
  }
}
