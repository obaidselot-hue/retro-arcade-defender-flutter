import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../defender_game/defender_game.dart';
import 'enemy.dart';
import 'enemy2.dart';

class Bullet extends SpriteComponent with CollisionCallbacks, HasGameReference<DefenderGame> {
  final double speed = 300;
  bool _hasHit = false;

  Bullet(Vector2 position)
      : super(
          size: Vector2(10, 20),
          position: position,
          anchor: Anchor.center,
        );

//LOGIC OF BULLET'S VISUAL APPEARANCE
  @override
  Future<void> onLoad() async {
    // Load the bullet image
    sprite = await game.loadSprite('bullet.png');
    // Add a hitbox so it can collide with things
    add(RectangleHitbox());
  }

//LOGIC OF PLAYER BULLET
  @override
  void update(double dt) {
    super.update(dt);
    // Move the bullet upwards at a constant speed
    y -= speed * dt;

    // remove bullet if it leaves the screen
    if (y < -height) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (_hasHit) return; // Prevent multiple hits

    if (other is Enemy) {
      if (!other.destroyed) {
        _hasHit = true;
        other.destroyed = true;
        game.handleEnemyDestroyed(other.position.clone(), byBullet: true);
        other.removeFromParent();
        removeFromParent();
      }
    } else if (other is Enemy2) {
      if (!other.destroyed) {
        _hasHit = true;
        other.destroyed = true;
        game.handleEnemyDestroyed(other.position.clone(), byBullet: true, enemyScore: 10);
        other.removeFromParent();
        removeFromParent();
      }
    }
    super.onCollision(points, other);
  }
}
