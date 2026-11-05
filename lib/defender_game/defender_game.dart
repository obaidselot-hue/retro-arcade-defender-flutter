import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'high_score_manager.dart';
import 'package:audioplayers/audioplayers.dart';

import '../components/player.dart';
import '../components/bullet.dart';
import '../components/enemy.dart';
import '../components/enemy2.dart';
import '../components/enemy_bullet.dart';
import '../components/explosion.dart';
import '../components/star_background.dart';
import 'custom_joystick.dart';
 
class DefenderGame extends FlameGame with HasCollisionDetection {
  late Player player;
  late JoystickComponent joystick;
  late HudButtonComponent fireButton;

  late Vector2 _initialPlayerPosition;

  final Random _rng = Random();

  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final ValueNotifier<int> health = ValueNotifier<int>(100);
  final ValueNotifier<bool> gameOver = ValueNotifier<bool>(false);

  final HighScoreManager _highScoreManager = HighScoreManager();
  final ValueNotifier<int> highScore = ValueNotifier<int>(0);
  static final ValueNotifier<bool> backgroundMusicEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> soundEffectsEnabled = ValueNotifier<bool>(true);

  bool isNewHighScore = false;

  String difficulty = 'normal'; // default to normal

  double _enemySpawnTimer = 0;
  double _enemySpawnInterval = 1.2; // Default to normal level interval
  final double moveSpeed = 200;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load high score
    highScore.value = await _highScoreManager.getHighScore();

    // ✅ Audio initialization
    await FlameAudio.audioCache.loadAll([
      'background.mp3',
      'shoot.mp3',
      'explosion.mp3',
      'gameover.mp3',
      'buttonclick.mp3',
      'scorecollect.mp3',
      'selfhealth.mp3',
    ]);
    // Start background music if enabled
    if (DefenderGame.backgroundMusicEnabled.value) {
      FlameAudio.bgm.play('background.mp3', volume: 0.4);
    }

    // ✅ Dynamic Star Background
    add(StarBackground(
      starCount: 150,
      twinkleSpeed: 1.5,
    )
      ..size = size
      ..position = Vector2.zero());

    //  Player
    player = Player()
      ..position = Vector2(size.x / 2, size.y - 90)
      ..anchor = Anchor.center;
    add(player);

    _initialPlayerPosition = player.position.clone();

    //  Joystick (bottom-left)
    joystick = JoystickComponent(
      knob: CustomJoystickKnob(),
      background: CustomJoystickBackground(),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
      knobRadius: 25,
      size: 100,
      // Remove position to let it be positioned by margin
    );
    joystick.anchor = Anchor.center;
    joystick.position = Vector2(50, size.y - 50);
    add(joystick);
    joystick.knob?.position = Vector2(joystick.size.x / 2 - joystick.size.x * 0.1, joystick.size.y / 2 - joystick.size.y * 0.1);

    //  Fire Button (bottom-right)
    fireButton = HudButtonComponent(
      button: NeonFireButtonComponent(radius: 31.5), // Decreased by 10% from 35
      buttonDown: NeonFireButtonComponent(radius: 31.5, isPressed: true), // Decreased by 10% from 35
      margin: EdgeInsets.only(
        right: 40,
        bottom: 44 - (size.y * 0.01), // Move 2% down from current position
      ),
      onPressed: fireBullet,
    );
    add(fireButton);

    // Remove the separate fire icon component (not needed for icon inside button)
    // final fireIcon = SpriteComponent()
    //   ..sprite = await loadSprite('fire_icon.png') // You need to add this asset
    //   ..size = Vector2(30, 30)
    //   ..position = Vector2(size.x - 40 - 35, size.y - 40 - 35)
    //   ..anchor = Anchor.center;
    // add(fireIcon);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver.value) return;

    // ✅ Enemy spawning
    _enemySpawnTimer += dt;
    if (_enemySpawnTimer > _enemySpawnInterval) {
      _enemySpawnTimer = 0;
      spawnEnemy();
    }

    // ✅ Player movement (X-axis only)
    if (joystick.direction != JoystickDirection.idle) {
      player.x += joystick.relativeDelta.x * moveSpeed * dt;

      if (player.x < player.width / 2) player.x = player.width / 2;
      if (player.x > size.x - player.width / 2) {
        player.x = size.x - player.width / 2;
      }
    }
  }

  void fireBullet() {
    final bulletPosition = Vector2(player.x, player.y - player.height / 2);
    final bullet = Bullet(bulletPosition);
    add(bullet);
    playShootSound();
  }

  void enemyFireBullet(Vector2 position) {
    final enemyBullet = EnemyBullet(position);
    add(enemyBullet);
  }

  void spawnEnemy() {
    final x = _rng.nextDouble() * (size.x - 40) + 20;
    double enemySpeed;
    bool spawnEnemy2 = _rng.nextDouble() < 0.2; // 20% chance to spawn Enemy2

    if (spawnEnemy2) {
      // Enemy2 speeds: easy=170, normal=240, hard=310
      if (difficulty == 'easy') {
        enemySpeed = 170;
      } else if (difficulty == 'normal') {
        enemySpeed = 240;
      } else if (difficulty == 'hard') {
        enemySpeed = 310;
      } else {
        enemySpeed = 240; // default normal
      }
      final enemy2 = Enemy2(Vector2(x, -30), enemySpeed);
      add(enemy2);
    } else {
      // Enemy speeds: easy=100, normal=170, hard=240
      if (difficulty == 'easy') {
        enemySpeed = 100;
      } else if (difficulty == 'normal') {
        enemySpeed = 170;
      } else if (difficulty == 'hard') {
        enemySpeed = 240;
      } else {
        enemySpeed = 100; // default normal
      }
      final enemy = Enemy(Vector2(x, -30), enemySpeed);
      add(enemy);
    }
  }

  void setDifficulty(String newDifficulty) {
    difficulty = newDifficulty;
    // Update spawn interval based on difficulty
    if (difficulty == 'easy') {
      _enemySpawnInterval = 1.5;
    } else if (difficulty == 'normal') {
      _enemySpawnInterval = 1.2;
    } else if (difficulty == 'hard') {
      _enemySpawnInterval = 0.9;
    } else {
      _enemySpawnInterval = 1.2; // default normal
    }
  }

// logic of score calculation 
  void handleEnemyDestroyed(Vector2 where, {bool byBullet = false, int enemyScore = 5}) {
    if (byBullet) {
      score.value += enemyScore;
      if (score.value > highScore.value) {
        highScore.value = score.value;
        isNewHighScore = true;
      }
    }
    add(Explosion(where));
    playExplosionSound();
  }


  void handlePlayerHit({int damage = 10}) {
    if (gameOver.value) return;

    health.value -= damage;

    // Play selfhealth audio when player is hit
    if (DefenderGame.soundEffectsEnabled.value) {
      FlameAudio.play('selfhealth.mp3', volume: 0.5);
    }

    if (health.value <= 0) {
      // Save high score on game over
      _highScoreManager.setHighScore(highScore.value);

      playGameOverSound();

      FlameAudio.bgm.stop();

      gameOver.value = true;

      // ✅ Show overlay when game ends
      overlays.add('GameOverMenu');

      pauseEngine();
    }
  }

  void resetGame() {
    // Save high score
    _highScoreManager.setHighScore(highScore.value);

    // Reset all values
    score.value = 0;
    health.value = 100;
    gameOver.value = false;
    isNewHighScore = false;

    // Remove enemies & bullets
    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    children.whereType<Enemy2>().forEach((e) => e.removeFromParent());
    children.whereType<Bullet>().forEach((b) => b.removeFromParent());
    children.whereType<EnemyBullet>().forEach((b) => b.removeFromParent());

    // Reset player position 15% up from the original position
    player.position.x = size.x / 2;
    player.position.y = size.y - 90 - (size.y * 0.15);

    // Remove overlay & resume
    overlays.remove('GameOverMenu');
    resumeEngine();

    // Restart background music if enabled
    if (DefenderGame.backgroundMusicEnabled.value) {
      FlameAudio.bgm.play('background.mp3', volume: 0.4);
    }
  }

  static void toggleBackgroundMusic(bool enabled) {
    DefenderGame.backgroundMusicEnabled.value = enabled;
    if (enabled) {
      FlameAudio.bgm.play('background.mp3', volume: 0.4);
    } else {
      FlameAudio.bgm.stop();
    }
  }

  static void toggleSoundEffects(bool enabled) {
    DefenderGame.soundEffectsEnabled.value = enabled;
    // Sound effects are checked before playing
  }

  void playShootSound() {
    if (DefenderGame.soundEffectsEnabled.value) {
      FlameAudio.play('shoot.mp3', volume: 0.3);
    }
  }

  void playExplosionSound() {
    if (DefenderGame.soundEffectsEnabled.value) {
      FlameAudio.play('explosion.mp3', volume: 0.4);
    }
  }

  void playGameOverSound() {
    if (DefenderGame.soundEffectsEnabled.value) {
      FlameAudio.play('gameover.mp3', volume: 0.5);
    }
  }

  static void playButtonClickSound() {
    if (DefenderGame.soundEffectsEnabled.value) {
      FlameAudio.play('buttonclick.mp3', volume: 0.3);
    }
  }

  void playScoreCollectSound() {
    if (DefenderGame.soundEffectsEnabled.value) {
      FlameAudio.play('scorecollect.mp3', volume: 0.3);
    }
  }
}

class NeonFireButtonComponent extends PositionComponent {
  final double radius;
  final bool isPressed;

  NeonFireButtonComponent({required this.radius, this.isPressed = false})
      : super(size: Vector2(radius * 2 + 40, radius * 2 + 40)); // Extra space for outer glow

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

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
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(isPressed ? 0.3 : 0.15),
          Colors.transparent,
        ],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sheenPaint);

    canvas.restore();
  }
}
