import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart' show GameWidget;
import 'package:behabior/core/core_game.dart';
import 'package:behabior/data/providers/game_state.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class GameScreen extends StatefulWidget {
  final int levelId;

  const GameScreen({super.key, required this.levelId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final CoreGame _game;
  Timer? _updateTimer;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<GameState>();
    _game = CoreGame(state);
    _game.startLevel(widget.levelId);
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _game.cleanup();
    super.dispose();
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: GameWidget(
              game: _game,
            ),
          ),
          _buildHUD(),
          if (_paused) _buildPauseOverlay(),
          if (_game.isGameOver()) _buildGameOverOverlay(),
          if (_game.isLevelComplete()) _buildLevelCompleteOverlay(),
        ],
      ),
    );
  }

  Widget _buildHUD() {
    final state = _game.gameState;
    final hp = _game.player.currentHealth / _game.player.maxHealth;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HP', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(
                    width: 120,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: hp.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: hp > 0.5 ? AppTheme.successColor : AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'SCORE: ${_game.scoreSystem.score}',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'LV ${widget.levelId}',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _togglePause,
                child: const Icon(Icons.pause, color: AppTheme.textPrimary, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PAUSED',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _togglePause,
              child: const Text('RESUME'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
              child: const Text('QUIT'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${_game.scoreSystem.score}',
              style: const TextStyle(fontSize: 24, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('BACK TO MENU'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCompleteOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'LEVEL COMPLETE!',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${_game.scoreSystem.score}',
              style: const TextStyle(fontSize: 24, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Coins: ${_game.gameState.coins}',
              style: const TextStyle(fontSize: 18, color: AppTheme.starColor),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}
