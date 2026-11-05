import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:retro_arcade_defender/defender_game/defender_game.dart';
import 'package:retro_arcade_defender/screens/game_over_screen.dart';
import 'package:retro_arcade_defender/screens/menu_screen.dart';
import 'package:retro_arcade_defender/widgets/health_bar.dart';


class GameScreen extends StatefulWidget {
  final String difficulty;

  const GameScreen({super.key, required this.difficulty});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late DefenderGame _game;

  @override
  void initState() {
    super.initState();
    _game = DefenderGame();
    _game.setDifficulty(widget.difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {
          'GameOverMenu': (BuildContext context, DefenderGame game) {
            return GameOverScreen(
              onRestart: () {
                game.isNewHighScore = false;
                game.resetGame();
                game.overlays.remove('GameOverMenu');
              },
              score: game.score.value,
              highScore: game.highScore.value,
              isNewHighScore: game.isNewHighScore,
            );
          },

          'HealthBar': (BuildContext context, DefenderGame game) {
            return HealthBar(game: game);
          },
          'PauseButton': (BuildContext context, DefenderGame game) {
            return Positioned(
              top: 10,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1), // Thin white border
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconButton(
                  onPressed: () {
                    DefenderGame.playButtonClickSound();
                    game.pauseEngine();
                    game.overlays.add('PauseMenu');
                  },
                  icon: const Icon(Icons.pause, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          },
          'PauseMenu': (BuildContext context, DefenderGame game) {
            return Container(
              color: Colors.black.withValues(alpha: 0.7),
              padding: const EdgeInsets.only(top: 50), // Lift the menu up a bit
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'PAUSED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
                        DefenderGame.playButtonClickSound();
                        game.resumeEngine();
                        game.overlays.remove('PauseMenu');
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                onPressed: () {
                  DefenderGame.playButtonClickSound();
                  game.overlays.add('AudioSettings');
                },
                      icon: const Icon(Icons.volume_up, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    IconButton(
                      onPressed: () {
                        DefenderGame.playButtonClickSound();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const MenuScreen()),
                        );
                      },
                      icon: const Icon(Icons.exit_to_app, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          'AudioButton': (BuildContext context, DefenderGame game) {
            return Positioned(
              top: 10,
              right: 80, // Position next to pause button
              child: IconButton(
                onPressed: () {
                  DefenderGame.playButtonClickSound();
                  game.overlays.add('AudioSettings');
                },
                icon: const Icon(Icons.volume_up, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                ),
              ),
            );
          },
          'AudioSettings': (BuildContext context, DefenderGame game) {
            return Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'AUDIO SETTINGS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Background Music Toggle
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Background Music',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 20),
                              ValueListenableBuilder<bool>(
                                valueListenable: DefenderGame.backgroundMusicEnabled,
                                builder: (context, enabled, child) {
                                  return Switch(
                                    value: enabled,
                                    onChanged: (value) {
                                      DefenderGame.playButtonClickSound();
                                      DefenderGame.toggleBackgroundMusic(value);
                                    },
                                    activeThumbColor: Colors.green,
                                  );
                                },
                              ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Sound Effects Toggle
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sound Effects',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 20),
                              ValueListenableBuilder<bool>(
                                valueListenable: DefenderGame.soundEffectsEnabled,
                                builder: (context, enabled, child) {
                                  return Switch(
                                    value: enabled,
                                    onChanged: (value) {
                                      DefenderGame.playButtonClickSound();
                                      DefenderGame.toggleSoundEffects(value);
                                    },
                                    activeThumbColor: Colors.green,
                                  );
                                },
                              ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        DefenderGame.playButtonClickSound();
                        game.overlays.remove('AudioSettings');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        },
        initialActiveOverlays: const ['HealthBar', 'PauseButton'],
      ),
    );
  }
}
