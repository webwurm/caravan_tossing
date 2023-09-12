import 'dart:async';

import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameRef<CaravanTossing> {
  Player({required this.sprite}) : super();

  final Sprite sprite;

  @override
  FutureOr<void> onLoad() {
    final SpriteComponent player = SpriteComponent(
      sprite: sprite,
      position: Vector2(100, gameRef.size.y - 250),
      size: Vector2(150, 80),
    );
    add(player);
    return super.onLoad();
  }
}
