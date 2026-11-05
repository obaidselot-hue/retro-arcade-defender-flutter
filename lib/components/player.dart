import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

class Player extends SpriteComponent with HasGameReference {
  double speed = 220;

  Player() : super(size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('player.png');
    position = Vector2(game.size.x / 2, game.size.y - 90 - (0.15 * game.size.y));
    add(RectangleHitbox()); // needed so enemies can collide with the player
  }

  void moveLeft(double dt) {
    x -= speed * dt;
    if (x < width / 2) x = width / 2;
  }

  void moveRight(double dt) {
    x += speed * dt;
    if (x > size.x - width / 2) x = size.x - width / 2;
  }

  void moveUp(double dt) {
    y -= speed * dt;
    if (y < height / 2) y = height / 2;
  }

  void moveDown(double dt) {
    y += speed * dt;
    if (y > size.y - height / 2) y = size.y - height / 2;
  }
}
