import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/data/models/level_model.dart';
import 'package:behabior/core/core_game.dart';
import 'package:behabior/core/engine/spawn_engine.dart';
import 'package:behabior/core/systems/audio_system.dart';
import 'package:behabior/core/systems/score_system.dart';
import 'package:behabior/core/systems/wave_system.dart';
import 'package:behabior/core/systems/achievement_system.dart';
import 'package:behabior/core/systems/skill_system.dart';
import 'package:behabior/ui/themes/app_theme.dart';
import 'package:behabior/ui/widgets/hud.dart';
import 'package:behabior/ui/widgets/pause_menu.dart';
import 'package:behabior/ui/widgets/game_over_overlay.dart';
import 'package:behabior/ui/widgets/wave_indicator.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with WidgetsBindingObserver {
  late CoreGame _game;
  late AudioSystem _audioSystem;
  late ScoreSystem _scoreSystem;
  late WaveSystem _waveSystem;
  late AchievementSystem _achievementSystem;
  late SkillSystem _skillSystem;
  bool _gameReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeGame();
  }

  void _initializeGame() {
    _audioSystem = AudioSystem();
    _scoreSystem = ScoreSystem();
    _achievementSystem = AchievementSystem(
      context.read<GameState>().achievementRepo,
    );
    _skillSystem = SkillSystem(context.read<GameState>());
    _waveSystem = WaveSystem(SpawnEngine());

    _game = CoreGame(
      audioSystem: _audioSystem,
      scoreSystem: _scoreSystem,
      waveSystem: _waveSystem,
      achievementSystem: _achievementSystem,
      skillSystem: _skillSystem,
    );

    _game.onLevelComplete = (levelId, stars) {
      context.read<GameState>().completeLevel(levelId, stars);
    };

    _game.onGameOver = () {
      context.read<GameState>().gameOver();
    };

    _initGame().then((_) {
      if (mounted) {
        setState(() => _gameReady = true);
      }
    }).catchError((Object error) {
      debugPrint('[BEHABIOR] Game init error: $error');
      if (mounted) {
        setState(() => _gameReady = true);
      }
    });
  }

  Future<void> _initGame() async {
    await _audioSystem.init();
    await _game.onLoad();

    final state = context.read<GameState>();
    final level = state.currentLevel;
    if (level != null) {
      _game.initializeLevel(state.currentLevelId, level);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _game.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _game.togglePause();
    }
  }

  void _onTapAttack() {
    // Attack in the direction the player is facing
    if (_game.player != null) {
      _game.performAttack(_game.player!.moveDirection);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameReady) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primary),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Flame game widget
          GameWidget(
            game: _game,
          ),

          // HUD overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HUD(
              score: _scoreSystem.score,
              health: _game.player?.health ?? 0,
              maxHealth: _game.player?.maxHealth ?? 100,
              waveNumber: _waveSystem.currentWave,
              totalWaves: _waveSystem.totalWaves,
              combo: _scoreSystem.combo,
              kills: _scoreSystem.kills,
              onPause: () => _showPauseMenu(),
            ),
          ),

          // Wave indicator
          if (_waveSystem.state == WaveState.starting)
            WaveIndicator(
              waveNumber: _waveSystem.currentWave,
              totalWaves: _waveSystem.totalWaves,
            ),

          // Attack button (right side, bottom)
          Positioned(
            right: 20,
            bottom: 40,
            child: GestureDetector(
              onTap: _onTapAttack,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),

          // Pause menu
          if (_game.isPaused)
            PauseMenu(
              onResume: () => setState(() => _game.togglePause()),
              onQuit: () => context.read<GameState>().navigateTo(AppScreen.menu),
              onRestart: () {
                _game.dispose();
                _initializeGame();
              },
            ),

          // Game over overlay
          if (_game.isGameOver || _game.isLevelComplete)
            GameOverOverlay(
              isVictory: _game.isLevelComplete,
              score: _scoreSystem.score,
              kills: _scoreSystem.kills,
              wavesCompleted: _waveSystem.currentWave,
              onRetry: () {
                _game.dispose();
                _initializeGame();
              },
              onMenu: () => context.read<GameState>().navigateTo(AppScreen.menu),
            ),
        ],
      ),
    );
  }

  void _showPauseMenu() {
    setState(() => _game.togglePause());
  }
}
