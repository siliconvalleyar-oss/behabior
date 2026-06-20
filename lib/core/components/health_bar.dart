import 'dart:ui';
import 'package:flame/components.dart';

class HealthBarComponent extends PositionComponent {
  final double maxHealth;
  double currentHealth;
  final double barWidth;
  final double barHeight;
  final Color fillColor;
  final Color bgColor;
  final bool showText;

  HealthBarComponent({
    required this.maxHealth,
    required this.currentHealth,
    this.barWidth = 40,
    this.barHeight = 4,
    this.fillColor = const Color(0xFF2ECC71),
    this.bgColor = const Color(0xFF333333),
    this.showText = false,
    super.position,
  });

  @override
  void render(Canvas canvas) {
    final ratio = (currentHealth / maxHealth).clamp(0.0, 1.0);

    final bgPaint = Paint()..color = bgColor;
    canvas.drawRect(
      Rect.fromLTWH(-barWidth / 2, -barHeight / 2, barWidth, barHeight),
      bgPaint,
    );

    final fillPaint = Paint()..color = fillColor;
    canvas.drawRect(
      Rect.fromLTWH(-barWidth / 2, -barHeight / 2, barWidth * ratio, barHeight),
      fillPaint,
    );

    final borderPaint = Paint()
      ..color = const Color(0xFF888888)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(
      Rect.fromLTWH(-barWidth / 2, -barHeight / 2, barWidth, barHeight),
      borderPaint,
    );
  }
}
