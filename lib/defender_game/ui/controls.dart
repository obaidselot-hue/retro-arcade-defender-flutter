import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onFire;

  const GameControls({
    super.key,
    required this.onLeft,
    required this.onRight,
    required this.onUp,
    required this.onDown,
    required this.onFire,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Left Button
          Positioned(
            bottom: 80,
            left: 20,
            child: _controlButton("◀", onLeft),
          ),

          // Right Button
          Positioned(
            bottom: 80,
            left: 100,
            child: _controlButton("▶", onRight),
          ),

          // Up Button
          Positioned(
            bottom: 150,
            left: 60,
            child: _controlButton("▲", onUp),
          ),

          // Down Button
          Positioned(
            bottom: 20,
            left: 60,
            child: _controlButton("▼", onDown),
          ),

          // Fire Button (right side)
          Positioned(
            bottom: 80,
            right: 40,
            child: _controlButton("FIRE", onFire),
          ),
        ],
      ),
    );
  }

  Widget _controlButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
