import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameRef<CaravanTossing> {
  final String name;
  final bool isRotating;
  static Vector2 spriteSize = Vector2(150, 85);
  Player({
    required this.name,
    this.isRotating = false,
  }) : super(size: spriteSize);

  final double minAngle = 0.00;
  final double maxAngle = -0.95; // Van moves from 0 to minus
  final double rotateSpeed = 0.8;
  double direction = -1;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player/caravan01.png');
    anchor = Anchor.center;
    priority = 15;
  }

  @override
  void update(double dt) {
    _rotateTheVan(dt);
  }

  void _rotateTheVan(double dt) {
    if (isRotating) {
      angle += (rotateSpeed * dt) * direction;
      if (angle < maxAngle || angle > minAngle) {
        direction *= -1;
      }
    }
  }
}
