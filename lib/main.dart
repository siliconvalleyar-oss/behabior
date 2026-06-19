import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:behabior/app.dart';
import 'package:behabior/data/repositories/save_repository.dart';
import 'package:behabior/data/repositories/level_repository.dart';
import 'package:behabior/data/repositories/achievement_repository.dart';
import 'package:behabior/data/providers/game_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Full screen immersive
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Initialize repositories
  final saveRepo = SaveRepository();
  final levelRepo = LevelRepository(saveRepo);
  final achievementRepo = AchievementRepository(saveRepo);
  final gameState = GameState(
    saveRepo: saveRepo,
    levelRepo: levelRepo,
    achievementRepo: achievementRepo,
  );

  await gameState.init();

  runApp(
    ChangeNotifierProvider<GameState>.value(
      value: gameState,
      child: const BehabiorApp(),
    ),
  );
}
