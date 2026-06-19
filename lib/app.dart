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
          case AppScreen.menu:
            return const MenuScreen();
          case AppScreen.playing:
            return const GameScreen();
          case AppScreen.paused:
            return const GameScreen();
          case AppScreen.levelSelect:
            return const LevelSelectScreen();
          case AppScreen.settings:
            return const SettingsScreen();
          case AppScreen.achievements:
            return const AchievementsScreen();
          case AppScreen.shop:
            return const ShopScreen();
          case AppScreen.gameOver:
            return const GameScreen();
        }
      },
    );
  }
}
