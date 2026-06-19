import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:behabior/ui/themes/app_theme.dart';

class WaveIndicator extends StatefulWidget {
  final int waveNumber;
  final int totalWaves;

  const WaveIndicator({
    super.key,
    required this.waveNumber,
    required this.totalWaves,
  });

  @override
  State<WaveIndicator> createState() => _WaveIndicatorState();
}

class _WaveIndicatorState extends State<WaveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _opacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return IgnorePointer(
            child: Container(
              color: Colors.black.withOpacity(0.3 * _opacityAnim.value),
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: Opacity(
                    opacity: _opacityAnim.value,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(0.4),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'WAVE ${widget.waveNumber}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.totalWaves - widget.waveNumber + 1} remaining',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
