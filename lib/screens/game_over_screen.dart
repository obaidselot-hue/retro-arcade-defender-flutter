import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';
import 'menu_screen.dart';
import '../defender_game/defender_game.dart';

class GameOverScreen extends StatelessWidget {
  final VoidCallback onRestart;
  final int score;
  final int highScore;
  final bool isNewHighScore;

  const GameOverScreen({super.key, required this.onRestart, required this.score, required this.highScore, required this.isNewHighScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (isNewHighScore)
              Text(
                'Highest Score: $highScore',
                style: const TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                'Score: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  DefenderGame.playButtonClickSound();
                  onRestart();
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  DefenderGame.playButtonClickSound();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MenuScreen()),
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text(
                  'Home',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  DefenderGame.playButtonClickSound();
                  SystemNavigator.pop();
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text(
                  'Quit',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
