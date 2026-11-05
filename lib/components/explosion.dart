import 'package:flame/components.dart';

class Explosion extends SpriteComponent {
  Explosion(Vector2 position)
      : super(position: position, size: Vector2.all(48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load('explosion.png');

    // Remove after a short duration for single frame explosion
    Future.delayed(const Duration(milliseconds: 10), () => removeFromParent());
  }
}
