import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../defender_game/defender_game.dart';
import 'player.dart';
import 'bullet.dart';
import 'explosion.dart';

class Enemy extends SpriteComponent with CollisionCallbacks, HasGameReference<DefenderGame> {
  late double speed;
  bool destroyed = false;
  double _bulletTimer = 0.0;
  double _bulletInterval = 1.0;

  Enemy(Vector2 position, double enemySpeed)
      : super(size: Vector2(40, 40), position: position, anchor: Anchor.center) {
    speed = enemySpeed;
  }

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('enemy.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update bullet interval based on difficulty
    if (game.difficulty == 'easy') {
      _bulletInterval = 2.0;
    } else if (game.difficulty == 'normal') {
      _bulletInterval = 1.0;
    } else if (game.difficulty == 'hard') {
      _bulletInterval = 0.5;
    }

    // Handle bullet firing
    _bulletTimer += dt;
    if (_bulletTimer >= _bulletInterval) {
      _bulletTimer = 0.0;
      game.enemyFireBullet(center.clone());
    }

    y += speed * dt;

    // ✅ remove enemy if it leaves screen
    if (y > game.size.y + height) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Player) {
      if (!destroyed) {
        destroyed = true;
        game.handlePlayerHit(damage: 5);
        game.handleEnemyDestroyed(center.clone(), enemyScore: 5);
        removeFromParent();
      }
    } else if (other is Bullet) {
      if (!destroyed) {
        destroyed = true;
        game.handleEnemyDestroyed(center.clone(), byBullet: true, enemyScore: 5);
        removeFromParent();
      }
    }
    super.onCollision(points, other);
  }


}
