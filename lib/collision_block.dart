import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent with CollisionCallbacks {
  CollisionBlock({
    super.position,
    super.size,
    debugMode = true,
  });

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2.zero(),
      size: size,
      collisionType: CollisionType.passive,
    ));
    return super.onLoad();
  }
}
