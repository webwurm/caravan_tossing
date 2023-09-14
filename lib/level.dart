import 'dart:async';
import 'dart:math';
import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/player.dart';
import 'package:caravan_tossing/statusline.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class Level extends World with HasGameRef<CaravanTossing> {
  late Player player;
  late SpriteAnimationComponent crow;
  late ParallaxComponent background;
  double bgSpeed = 0;
  Random random = Random();
  String statusBarText = 'Drücke rauf, runter und dann die Leertaste!';
  late Statusline statusLine;

  @override
  FutureOr<void> onLoad() {
    _addBackground();
    _addPlayer();

    statusLine = Statusline(text: statusBarText);
    add(statusLine);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    crow.position.x += 2;
    crow.position.y += (random.nextDouble() - 0.5) * 2;
    bgSpeed = player.velocity.x * 0.1;
    background.parallax?.baseVelocity = Vector2(bgSpeed, 0);
  }

  void _addBackground() async {
    background = await gameRef.loadParallaxComponent(
      [
        ParallaxImageData('background/background01.png'),
        ParallaxImageData('background/sky01.png'),
        ParallaxImageData('background/treeline01.png')
      ],
      baseVelocity: Vector2(bgSpeed, 0),
      velocityMultiplierDelta: Vector2(10, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height,
    );
    add(background);

    // Crow
    final crowAnimation = await gameRef.loadSpriteAnimation(
        'background/crow 350x400 4x3.png',
        SpriteAnimationData.sequenced(
          amount: 12,
          stepTime: 0.1,
          textureSize: Vector2(350, 400),
          amountPerRow: 4,
        ));

    crow = SpriteAnimationComponent(
      animation: crowAnimation,
      priority: 11,
      scale: Vector2.all(0.15),
      position: Vector2(-20, 70),
      anchor: Anchor.center,
    );

    add(crow);
  }

  void _addPlayer() async {
    player = Player(
      name: 'Player1',
    );
    player.position = Vector2(200, gameRef.size.y - 250);
    add(player);
  }
}
