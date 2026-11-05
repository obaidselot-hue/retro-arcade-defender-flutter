import 'package:flutter/material.dart';
import 'package:retro_arcade_defender/defender_game/defender_game.dart';

class PlayerPosition extends StatelessWidget {
  final DefenderGame game;

  const PlayerPosition({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      left: 100, // increased x axis
      child: Text(
        'Spaceship X: ${game.player.position.x.toInt()}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 4.0,
              color: Colors.black,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
    );
  }
}
