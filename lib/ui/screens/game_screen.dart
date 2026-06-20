import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flame/game.dart' show GameWidget;
import 'package:behabior/core/dino_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final DinoGame _game;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _game = DinoGame();
    _updateTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _game.removeAll(_game.children);
    super.dispose();
  }

  void _onTap() {
    _game.handleTap();
  }

  void _onTapCancel() {
    _game.handleRelease();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: GestureDetector(
          onTap: _onTap,
          onTapCancel: _onTapCancel,
          child: GameWidget(
            game: _game,
          ),
        ),
      ),
    );
  }
}
