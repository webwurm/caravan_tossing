import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:flame/components.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';

class Player extends SpriteComponent
    with HasGameRef<CaravanTossing>, KeyboardHandler {
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
  }

  void _rotateTheVan(double dt) {
    if (isRotating) {
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

    if (isUpKeyPressed) {
      direction = -1; // Set direction to -1 for 'W' key
    } else if (isDownKeyPressed) {
      direction = 1; // Set direction to 1 for 'S' key
    } else {
      direction = 0;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
