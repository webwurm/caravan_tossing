import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/collision_block.dart';
import 'package:caravan_tossing/custom_hitbox.dart';
import 'package:caravan_tossing/force_bar.dart';
import 'package:caravan_tossing/utils.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Player extends SpriteComponent
    with HasGameRef<CaravanTossing>, KeyboardHandler {
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
  double pushForce = 0;
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
  late ForceBar forceBar;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player/caravan01.png');
    anchor = Anchor.center;
    priority = 15;
    debugMode = true;

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));

    forceBar = ForceBar();
    add(forceBar);
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

      _checkCollision();
    }
  }

  void _shootTheVan() {
    isFlying = true;
    canRotate = false;

    pushForce = forceBar.force;
    forceBar.velocity = 0;
    remove(forceBar);

    velocity = calculateTossVelocity(angle, pushForce);
  }

  void _rotateTheVan(double dt) {
    if (canRotate) {
      if (((direction > 0) && (angle < minAngle)) ||
          ((direction < 0) && (angle > maxAngle))) {
        angle += (rotateSpeed * dt) * direction;
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isSpaceKeyPressed = keysPressed.contains(LogicalKeyboardKey.space);

    if (canRotate) {
      if (isUpKeyPressed) {
        direction = -1; // Set direction to -1 for 'W' key
      } else if (isDownKeyPressed) {
        direction = 1; // Set direction to 1 for 'S' key
      } else if (isSpaceKeyPressed) {
        _shootTheVan();
      } else {
        direction = 0;
      }
    }
    return super.onKeyEvent(event, keysPressed);
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
