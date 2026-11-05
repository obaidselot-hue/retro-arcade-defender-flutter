import 'package:flutter/material.dart';
import '../../defender_game/defender_game.dart';

class GameHud extends StatelessWidget {
  final DefenderGame game;
  const GameHud({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 22,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SCORE
          ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (_, value, __) => Text(
              'Score: $value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // HEALTH BAR
          ValueListenableBuilder<int>(
            valueListenable: game.health,
            builder: (_, hp, __) {
              final percent = hp / 3.0;
              return Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percent.clamp(0, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: hp >= 2 ? Colors.greenAccent : (hp == 1 ? Colors.orangeAccent : Colors.redAccent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
