import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/collision_block.dart';
import 'package:caravan_tossing/custom_hitbox.dart';
import 'package:caravan_tossing/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent
    with HasGameRef<CaravanTossing>, CollisionCallbacks {
  final String name;
  static Vector2 spriteSize = Vector2(150, 85);
  Player({
    required this.name,
  }) : super(size: spriteSize);

  bool canRotate = true;
  bool isFlying = false;
  bool hasLanded = false;
  final double minAngle = 0.00;
  final double maxAngle = -0.95; // Van moves from 0 to minus
  final double rotateSpeed = 0.8;
  final double bounceForce = 1.1;
  final double gravity = 0.7;
  final double airDensity = 0.99;
  Vector2 velocity = Vector2.zero();
  int direction = 0;
  double distanceVan = 0;
  int distanceVanSum = 0;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 10,
    width: 135,
    height: 70,
  );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player/caravan01.png');
    anchor = Anchor.center;
    priority = 15;
    debugMode = true;
    print(collisionBlocks.length);

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
  }

  @override
  void update(double dt) {
    _rotateTheVan(dt);

    if (isFlying) {
      position += Vector2(0, velocity.y) * 0.5;
      velocity += Vector2(0, gravity);
      velocity *= airDensity;
      distanceVan += (velocity.x) / 100;
      distanceVanSum = distanceVan.floor();
      gameRef.world.statusLine.text = 'Meter: $distanceVanSum';
      angle += 0.01;

      //_checkCollision();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    print('Collision in player');
    super.onCollisionStart(intersectionPoints, other);
  }

  void shootTheVan(double force) {
    isFlying = true;
    canRotate = false;

    velocity = calculateTossVelocity(angle, force);
  }

  void _rotateTheVan(double dt) {
    if (canRotate) {
      if (((direction > 0) && (angle < minAngle)) ||
          ((direction < 0) && (angle > maxAngle))) {
        angle += (rotateSpeed * dt) * direction;
      }
    }
  }

  void _checkCollision() {
    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        // if too slow, it's over...
        if ((velocity.x < 1) && (velocity.y < 15)) {
          isFlying = false;
          velocity = Vector2.zero();
          gameRef.overlays.add('GameOver');
        } else {
          // ...otherwise, bounce
          velocity.y *= -1;
          angle += 0.5;
        }
      }
    }
  }
}
