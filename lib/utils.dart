import 'dart:math';
import 'package:flame/components.dart';

Vector2 calculateTossVelocity(double rotationAngleRadians, double force) {
  // Convert the rotation angle to the direction angle
  double directionAngleRadians = 4 * pi / 2.0 - rotationAngleRadians;

  // Calculate the horizontal and vertical components of velocity
  double velocityX = force * cos(directionAngleRadians);
  double velocityY =
      -force * sin(directionAngleRadians); // Negative for upward direction

  // Create and return the velocity vector
  return Vector2(velocityX, velocityY);
}

double calculateTossAngle(Vector2 forceVector) {
  // Calculate the magnitude of the force vector
  //double magnitude = forceVector.length;

  // Calculate the angle using atan2 function
  double angleRadians = atan2(-forceVector.y, forceVector.x);

  // Convert the angle to rotation angle
  double rotationAngleRadians = 4 * pi / 2.0 - angleRadians;

  return rotationAngleRadians;
}

bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.position.x;
  final blockY = block.position.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  // if flipped
  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;

  // platforms check only for bottom corner
  //final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  final fixedY = playerY;

  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
