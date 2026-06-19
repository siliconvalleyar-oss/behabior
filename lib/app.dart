import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/ui/themes/app_theme.dart';
import 'package:behabior/ui/screens/menu_screen.dart';
import 'package:behabior/ui/screens/game_screen.dart';
import 'package:behabior/ui/screens/level_select_screen.dart';
import 'package:behabior/ui/screens/settings_screen.dart';
import 'package:behabior/ui/screens/achievements_screen.dart';
import 'package:behabior/ui/screens/shop_screen.dart';

class BehabiorApp extends StatelessWidget {
  final bool debug;

  const BehabiorApp({super.key, this.debug = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Behabior',
      debugShowCheckedModeBanner: debug,
      theme: AppTheme.darkTheme,
      home: const _AppRouter(),
    );
  }
}

class _AppRouter extends StatelessWidget {
  const _AppRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, _) {
        switch (gameState.currentScreen) {
          case GameScreen.menu:
            return const MenuScreen();
          case GameScreen.playing:
            return const GameScreen();
          case GameScreen.paused:
            return const GameScreen(); // Pause handled inside game screen
          case GameScreen.levelSelect:
            return const LevelSelectScreen();
          case GameScreen.settings:
            return const SettingsScreen();
          case GameScreen.achievements:
            return const AchievementsScreen();
          case GameScreen.shop:
            return const ShopScreen();
          case GameScreen.gameOver:
            return const GameScreen(); // Handled inside game screen
        }
      },
    );
  }
}
