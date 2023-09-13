import 'dart:math';

import 'package:caravan_tossing/caravan_tossing.dart';
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
  bool isShooting = false;
  final double minAngle = 0.00;
  final double maxAngle = -0.95; // Van moves from 0 to minus
  final double rotateSpeed = 0.8;
  int direction = 0;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('player/caravan01.png');
    anchor = Anchor.center;
    priority = 15;
  }

  @override
  void update(double dt) {
    _rotateTheVan(dt);

    if (isShooting) {
      _shootTheVan(dt);
    }
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
        direction = 0;
        isShooting = true;
        canRotate = false;
      } else {
        direction = 0;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _shootTheVan(double dt) {
    position += _calculateTossVelocity(angle, 10);
  }

  // Calculate the velocity vector
  Vector2 _calculateTossVelocity(double rotationAngleRadians, double force) {
    // Convert the rotation angle to the direction angle
    double directionAngleRadians = 4 * pi / 2.0 - rotationAngleRadians;

    // Calculate the horizontal and vertical components of velocity
    double velocityX = force * cos(directionAngleRadians);
    double velocityY =
        -force * sin(directionAngleRadians); // Negative for upward direction

    // Create and return the velocity vector
    return Vector2(velocityX, velocityY);
  }
}
