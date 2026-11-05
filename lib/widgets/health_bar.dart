import 'package:flutter/material.dart';
import 'package:retro_arcade_defender/defender_game/defender_game.dart';

// Custom painter for dotted line
class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HealthBar extends StatelessWidget {
  final DefenderGame game;

  const HealthBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final healthBarWidth = screenSize.width * 0.2; // 20% of screen width
    final isMobile = screenSize.width < 600;
    final fontSize = isMobile ? screenSize.width * 0.04 : screenSize.width * 0.025; // 4% for mobile, 2.5% for desktop
    final topPosition = screenSize.height * 0.02; // 2% of screen height
    final leftPosition = screenSize.width * 0.02; // 2% of screen width

    return Stack(
      children: [
        // Score display on left
        Positioned(
          top: topPosition,
          left: leftPosition,
          child: ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (context, score, child) {
              return Text(
                'Score: $score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Difficulty indicator below score
        Positioned(
          top: topPosition + fontSize + 8, // Position below score with some spacing
          left: leftPosition,
          child: Builder(
            builder: (context) {
              Color dotColor;
              String difficultyText;

              switch (game.difficulty) {
                case 'easy':
                  dotColor = Colors.green;
                  difficultyText = 'Easy';
                  break;
                case 'normal':
                  dotColor = Colors.yellow;
                  difficultyText = 'Normal';
                  break;
                case 'hard':
                  dotColor = Colors.red;
                  difficultyText = 'Hard';
                  break;
                default:
                  dotColor = Colors.green;
                  difficultyText = 'Easy';
                  break;
              }

              return Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    difficultyText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize * 0.8, // Slightly smaller than score text
                      fontStyle: FontStyle.italic,
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
                ],
              );
            },
          ),
        ),
        // Red dotted line below difficulty indicator
        Positioned(
          top: topPosition + fontSize + 8 + fontSize * 0.8 + 12, // Below difficulty text with spacing
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            child: CustomPaint(
              painter: DottedLinePainter(color: Colors.red),
            ),
          ),
        ),
        // Health bar with number in center
        Positioned(
          top: topPosition,
          left: 0,
          right: 0,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Numeric health value
                ValueListenableBuilder<int>(
                  valueListenable: game.health,
                  builder: (context, health, child) {
                    return Text(
                      '$health%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(width: screenSize.width * 0.01), // 1% of screen width
                // Health bar with responsive width
                Container(
                  width: healthBarWidth,
                  height: screenSize.height * 0.025, // 2.5% of screen height
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ValueListenableBuilder<int>(
                      valueListenable: game.health,
                      builder: (context, health, child) {
                        return LinearProgressIndicator(
                          value: health / 100.0,
                          backgroundColor: Colors.red.withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            health > 50
                                ? Colors.green
                                : health > 25
                                    ? Colors.yellow
                                    : Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
