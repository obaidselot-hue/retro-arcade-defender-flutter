import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// A Flutter widget version of the NeonFireButton.
/// This renders a glowing red button without any icon.
class NeonFireButtonWidget extends StatefulWidget {
  final double radius;
  final bool enabled;
  final VoidCallback? onPressed;

  const NeonFireButtonWidget({
    Key? key,
    this.radius = 35,
    this.enabled = true,
    this.onPressed,
  }) : super(key: key);

  @override
  _NeonFireButtonWidgetState createState() => _NeonFireButtonWidgetState();
}

class _NeonFireButtonWidgetState extends State<NeonFireButtonWidget> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled) {
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled) {
      setState(() {
        _isPressed = false;
      });
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (widget.enabled) {
      setState(() {
        _isPressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Increase canvas size to accommodate the outer orange border
    final canvasSize = widget.radius * 2 + 20; // Extra space for outer border
    return GestureDetector(
      onTapDown: widget.enabled ? _handleTapDown : null,
      onTapUp: widget.enabled ? _handleTapUp : null,
      onTapCancel: widget.enabled ? _handleTapCancel : null,
      child: CustomPaint(
        size: Size(canvasSize, canvasSize),
        painter: _NeonFireButtonPainter(
          radius: widget.radius,
          isPressed: _isPressed,
          isEnabled: widget.enabled,
        ),
      ),
    );
  }
}

class _NeonFireButtonPainter extends CustomPainter {
  final double radius;
  final bool isPressed;
  final bool isEnabled;

  _NeonFireButtonPainter({
    required this.radius,
    required this.isPressed,
    required this.isEnabled,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);

    // Neon glow outer ring with soft pulse animation (increased opacity)
    final glowPaint = Paint()
      ..color = isPressed
          ? Colors.redAccent.withOpacity(0.9)
          : Colors.red.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, isPressed ? 15.0 : 10.0);

    canvas.drawCircle(center, radius + 2, glowPaint);

    // Double border with orange neon color and shadow for lightning effect
    final doubleBorderPaint = Paint()
      ..color = Colors.orangeAccent.withOpacity(0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 18.0);

    canvas.drawCircle(center, radius + 8, doubleBorderPaint);

    // Additional outer glow for more dramatic lightning effect
    final outerGlowPaint = Paint()
      ..color = Colors.orange.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 35.0);

    canvas.drawCircle(center, radius + 12, outerGlowPaint);

    // Extra outer ring for enhanced lightning effect
    final extraGlowPaint = Paint()
      ..color = Colors.orange.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 45.0);

    canvas.drawCircle(center, radius + 16, extraGlowPaint);

    // Button scale for pressed state
    final scale = isPressed ? 0.92 : 1.0;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale);
    canvas.translate(-center.dx, -center.dy);

    // Radial gradient base with glossy sheen
    final buttonPaint = Paint()
      ..shader = RadialGradient(
        colors: isPressed
            ? [
                Colors.red.shade200,
                Colors.red.shade800,
                Colors.red.shade900,
              ]
            : [
                Colors.red.shade500,
                Colors.red.shade800,
                Colors.red.shade900,
              ],
        stops: [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, buttonPaint);

    // Glossy sheen highlight
    final sheenPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          Colors.white.withOpacity(isPressed ? 0.3 : 0.15),
          Colors.transparent,
        ],
        [0.0, 1.0],
      );

    canvas.drawCircle(center, radius, sheenPaint);

    canvas.restore();

    // Disabled overlay
    if (!isEnabled) {
      final overlayPaint = Paint()..color = Colors.black.withOpacity(0.4);
      canvas.drawCircle(center, radius, overlayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
