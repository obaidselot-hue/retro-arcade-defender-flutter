import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../defender_game/defender_game.dart';
import 'player.dart';

class EnemyBullet extends SpriteComponent with CollisionCallbacks, HasGameReference<DefenderGame> {
  final double speed = 250;
  late Vector2 direction;

  EnemyBullet(Vector2 position, [Vector2? targetPosition])
      : super(
          size: Vector2(8, 16),
          position: position,
          anchor: Anchor.center,
        ) {
    if (targetPosition != null) {
      direction = (targetPosition - position).normalized();
    } else {
      direction = Vector2(0, 1); // Move downwards
    }
  }

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('enemybullet.png');
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;

    // Remove bullet if it leaves the screen
    if (position.x < -width || position.x > game.size.x + width ||
        position.y < -height || position.y > game.size.y + height) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    // Check if the object we hit is the Player
    if (other is Player) {
      // Tell the main game logic the player took damage
      game.handlePlayerHit(damage: 2); // Example damage value
      // Remove this object (the enemy bullet/ship) from the game
      removeFromParent();
    }
    // Let the parent class handle any other collision logic
    super.onCollision(points, other);
  }
}
