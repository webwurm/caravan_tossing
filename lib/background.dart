import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class Background extends ParallaxComponent {
  @override
  FutureOr<void> onLoad() async {
    await gameRef.loadParallaxComponent(
      [
        ParallaxImageData('background/background01.png'),
        ParallaxImageData('background/sky01.png'),
        ParallaxImageData('background/treeline01.png')
      ],
      baseVelocity: Vector2(0.1, 0),
      velocityMultiplierDelta: Vector2(10, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height,
    );
  }
}
