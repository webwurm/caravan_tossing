import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent with CollisionCallbacks {
  CollisionBlock({
    super.position,
    super.size,
    debugMode = true,
  });
}
