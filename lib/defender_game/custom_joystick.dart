import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CustomJoystickKnob extends PositionComponent {
  static const double knobRadius = 25.0;

  CustomJoystickKnob() : super(size: Vector2(knobRadius * 2, knobRadius * 2));

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint paint = Paint()
      ..color = const Color(0xFF00FFAA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final center = Offset(knobRadius, knobRadius);

    // Draw 3 arcs with gaps spaced evenly around the knob
    final arcRect = Rect.fromCircle(center: center, radius: knobRadius - 2);
    final startAngles = [0.0, 2.0, 4.0]; // radians
    final sweepAngle = 1.0; // radians

    for (final startAngle in startAngles) {
      canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
    }

    // Draw spaceship icon in center using simple path
    final Path spaceshipPath = Path();
    final double w = knobRadius * 1.2;
    final double h = knobRadius * 1.2;

    // Adjust the spaceship icon position to be visually centered
    spaceshipPath.moveTo(center.dx, center.dy - h * 0.4);
    spaceshipPath.lineTo(center.dx - w * 0.15, center.dy + h * 0.3);
    spaceshipPath.lineTo(center.dx, center.dy + h * 0.1);
    spaceshipPath.lineTo(center.dx + w * 0.15, center.dy + h * 0.3);
    spaceshipPath.close();

    final Paint spaceshipPaint = Paint()
      ..color = const Color(0xFF00FFAA)
      ..style = PaintingStyle.fill;

    canvas.drawPath(spaceshipPath, spaceshipPaint);
  }

  @override
  void onMount() {
    super.onMount();
    anchor = Anchor.center;
    position = size / 2;
  }
}

class CustomJoystickBackground extends PositionComponent {
  static const double radius = 50.0;

  CustomJoystickBackground() : super(size: Vector2(radius * 2, radius * 2));

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint paint = Paint()
      ..color = const Color(0x3300FFAA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final center = Offset(size.x / 2, size.y / 2);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius - 3);

    // Draw 3 arcs with gaps spaced evenly around the background
    final startAngles = [0.0, 2.0, 4.0]; // radians
    final sweepAngle = 1.0; // radians

    for (final startAngle in startAngles) {
      canvas.drawArc(arcRect, startAngle, sweepAngle, false, paint);
    }
  }

  @override
  void onMount() {
    super.onMount();
    anchor = Anchor.center;
    position = size / 2;
  }
}
