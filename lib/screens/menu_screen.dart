import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'game_screen.dart';
import '../defender_game/defender_game.dart';

class MenuScreen extends StatelessWidget {
  static String selectedDifficulty = 'easy';

  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/main_background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              const Text(
                "🚀 Retro Arcade Defender",
                style: TextStyle(color: Colors.cyan, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              */
              const SizedBox(height: 60),
              // Removed high score display as per user request
              const SizedBox(height: 20),
              Transform.scale(
                scale: 1.1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(side: BorderSide(color: Colors.cyan, width: 2)).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.cyan.withValues(alpha: 0.3);
                      }
                      return null;
                    }),
                  ),
              onPressed: () {
                DefenderGame.playButtonClickSound();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen(difficulty: selectedDifficulty)),
                );
              },
                  child: const Text("▶ PLAY"),
                ),
              ),
              const SizedBox(height: 10.5),
              Transform.scale(
                scale: 1.1,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(side: BorderSide(color: Colors.cyan, width: 2)).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.cyan.withValues(alpha: 0.3);
                      }
                      return null;
                    }),
                  ),
                  onPressed: () {
                    DefenderGame.playButtonClickSound();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Select Difficulty Level'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            RadioListTile(
                              value: 'easy',
                              groupValue: selectedDifficulty,
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (value) {
                                DefenderGame.playButtonClickSound();
                                selectedDifficulty = value as String;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Easy level selected')),
                                );
                              },
                              title: Row(
                                children: [
                                  const Icon(Icons.star_border),
                                  const SizedBox(width: 8),
                                  const Text('Easy'),
                                ],
                              ),
                            ),
                            RadioListTile(
                              value: 'normal',
                              groupValue: selectedDifficulty,
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (value) {
                                DefenderGame.playButtonClickSound();
                                selectedDifficulty = value as String;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Normal level selected')),
                                );
                              },
                              title: Row(
                                children: [
                                  const Icon(Icons.star_half),
                                  const SizedBox(width: 8),
                                  const Text('Normal'),
                                ],
                              ),
                            ),
                            RadioListTile(
                              value: 'hard',
                              groupValue: selectedDifficulty,
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (value) {
                                DefenderGame.playButtonClickSound();
                                selectedDifficulty = value as String;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Hard level selected')),
                                );
                              },
                              title: Row(
                                children: [
                                  const Icon(Icons.star),
                                  const SizedBox(width: 8),
                                  const Text('Hard'),
                                ],
                              ),
                            ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                DefenderGame.playButtonClickSound();
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.leaderboard),
                  label: const Text('Level'),
                ),
              ),
              const SizedBox(height: 10.5),
              Transform.scale(
                scale: 1.1,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(side: BorderSide(color: Colors.cyan, width: 2)).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.cyan.withValues(alpha: 0.3);
                      }
                      return null;
                    }),
                  ),
                  onPressed: () {
                    DefenderGame.playButtonClickSound();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Audio Settings'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Background Music Toggle
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Background Music',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
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
                                      fontSize: 16,
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
                                        activeColor: Colors.green,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                DefenderGame.playButtonClickSound();
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Audio'),
                ),
              ),
              const SizedBox(height: 10.5),
              Transform.scale(
                scale: 1.1,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(side: BorderSide(color: Colors.cyan, width: 2)).copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Colors.cyan.withValues(alpha: 0.3);
                      }
                      return null;
                    }),
                  ),
                  onPressed: () {
                    DefenderGame.playButtonClickSound();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.cyan, width: 1),
                          ),
                          title: const Text('About', style: TextStyle(color: Colors.white)),
                          content: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(color: Colors.white, fontSize: 13),
                                  children: [
                                    TextSpan(text: '📖 About Retro Arcade Defender\n\nRetro Arcade Defender is a classic space shooter game where you pilot a spaceship to protect the galaxy from alien invaders. With simple controls, scoring, and exciting enemy encounters, the game recreates the charm of old-school arcade shooters in a mobile-friendly design.\n\n--------------------------------------------------\n\n👥 Team Credits\n\n💻 Backend Development → \n'),
                                    TextSpan(text: '    Obaid Selot\n\n', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 14)),
                                    TextSpan(text: '🎨 GUI Design & Testing → \n'),
                                    TextSpan(text: '    Shazia Barmare\n\n', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 14)),
                                    TextSpan(text: '\n\nTogether, we built Retro Arcade Defender as a creative project to bring the retro arcade experience to life with a modern touch.'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(backgroundColor: Colors.cyan.withValues(alpha: 0.3)),
                              onPressed: () {
                                DefenderGame.playButtonClickSound();
                                Navigator.pop(context);
                              },
                              child: const Text('Close', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.info),
                  label: const Text('About'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
