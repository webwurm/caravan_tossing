import 'dart:math';

import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/utils.dart';
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
  final double pushForce = 70;
  final double bounceForce = 1.1;
  final double gravity = 0.9;
  final double airDensity = 0.99;
  double bottomY = 320;
  Vector2 velocity = Vector2.zero();
  int direction = 0;
  double distanceVan = 0;
  int distanceVanSum = 0;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player/caravan01.png');
    anchor = Anchor.center;
    priority = 15;
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

      // bounce...
      if (position.y >= bottomY) {
        print('jump $velocity | $position');
        // ...except when too slow
        if ((velocity.x < 1) && (velocity.y < 15)) {
          isFlying = false;
          velocity = Vector2.zero();
        } else {
          velocity.y *= -1;
          angle += 0.5;
        }
      }
    }
  }

  void _shootTheVan() {
    isFlying = true;
    canRotate = false;
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
}
