import 'dart:async';
import 'dart:ui';

import 'package:caravan_tossing/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class CaravanTossing extends FlameGame with HasKeyboardHandlerComponents {
  // Hintergrundfarbe setzen
  @override
  Color backgroundColor() => const Color.fromARGB(255, 166, 128, 247);
  bool gameStopped = false;

  late CameraComponent cam;
  Level world = Level();

  @override
  FutureOr<void> onLoad() async {
    // Bilder in Cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    )..viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    return super.onLoad();
  }
}
