import 'dart:async';

import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/custom_hitbox.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ExplosiveBarrel extends SpriteComponent
    with HasGameRef<CaravanTossing>, CollisionCallbacks {
  ExplosiveBarrel({super.position, super.size});

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 8,
    offsetY: 0,
    width: 32,
    height: 48,
  );

  @override
  FutureOr<void> onLoad() {
    priority = 50;
    debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
      collisionType: CollisionType.passive,
    ));
    sprite = Sprite(game.images.fromCache('items/explosive_barrel01.png'));
    return super.onLoad();
  }
}
