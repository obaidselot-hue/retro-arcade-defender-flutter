import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class StarBackground extends PositionComponent with HasGameReference {
  final Random _random = Random();              // Used to generate random star positions and sizes
  final List<Star> _stars = [];                 // Stores all stars currently in the background
  final int starCount;                          // Number of stars on the screen
  final double twinkleSpeed;                    // Speed at which stars twinkle

  StarBackground({
    this.starCount = 150,                       // Default: 150 stars
    this.twinkleSpeed = 2.0,                    // Default twinkling speed
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Split stars into two groups for alternating twinkle patterns
    final halfCount = starCount ~/ 2;

    // First group: normal twinkling
    for (int i = 0; i < halfCount; i++) {
      final star = Star(
        position: Vector2(
          _random.nextDouble() * size.x,        // Random horizontal position
          _random.nextDouble() * size.y,        // Random vertical position
        ),
        twinkleSpeed: twinkleSpeed,
        phaseOffset: 0.0,                       // Normal twinkling phase
      );
      _stars.add(star);
      add(star);                                // Add to the game world
    }

    // Second group: opposite twinkling (phase offset π)
    for (int i = 0; i < halfCount; i++) {
      final star = Star(
        position: Vector2(
          _random.nextDouble() * size.x,
          _random.nextDouble() * size.y,
        ),
        twinkleSpeed: twinkleSpeed,
        phaseOffset: pi,                        // Opposite twinkling
      );
      _stars.add(star);
      add(star);
    }
  }

  // Adjust star positions if screen size changes
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    for (final star in _stars) {
      if (star.position.x > size.x) star.position.x = _random.nextDouble() * size.x;
      if (star.position.y > size.y) star.position.y = _random.nextDouble() * size.y;
    }
  }
}


class Star extends PositionComponent {
  final double twinkleSpeed;      // How fast the star blinks
  final double phaseOffset;       // Used to make stars blink at different times
  double _twinklePhase = 0.0;     // Internal timer for the blinking pattern
  final double _size;             // Size of the star

  Star({
    required Vector2 position,
    this.twinkleSpeed = 2.0,
    this.phaseOffset = 0.0,
  }) : _size = Random().nextDouble() * 2 + 1 {  // Random size between 1–3 px
    this.position = position;
    size = Vector2.all(_size);
    _twinklePhase = phaseOffset;                 // Start twinkling with phase offset
  }

  @override
  void update(double dt) {
    super.update(dt);
    _twinklePhase += twinkleSpeed * dt;          // Update blinking animation
    if (_twinklePhase > 2 * pi) _twinklePhase -= 2 * pi;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Brightness oscillates between 0.3 and 1.0 using sine wave
    final opacity = 0.3 + (sin(_twinklePhase) + 1) / 2 * 0.7;

    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    // Draw a simple circular star
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), _size / 2, paint);
  }
}