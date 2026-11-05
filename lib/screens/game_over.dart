import 'package:flutter/material.dart';
import 'game_screen.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final String difficulty;

  const GameOverScreen({super.key, required this.score, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('GAME OVER',
                style: TextStyle(color: Colors.redAccent, fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Score: $score', style: const TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen(difficulty: difficulty)),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, padding: const EdgeInsets.all(16)),
              child: const Text('RESTART', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
