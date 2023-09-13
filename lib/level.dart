import 'dart:async';
import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/player.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class Level extends World with HasGameRef<CaravanTossing> {
  late Player player;

  @override
  FutureOr<void> onLoad() {
    _addBackground();
    _addPlayer();

    return super.onLoad();
  }

  void _addBackground() async {
    Parallax parallaxSky = await gameRef.loadParallax(
      [ParallaxImageData('background/background01.png')],
      baseVelocity: Vector2(0, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height,
    );

    ParallaxComponent bgSky = ParallaxComponent(
      parallax: parallaxSky,
      priority: -10,
    );
    add(bgSky);

    Parallax parallaxClouds = await gameRef.loadParallax(
      [ParallaxImageData('background/sky01.png')],
      baseVelocity: Vector2(15, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height,
      alignment: Alignment.topCenter,
    );

    ParallaxComponent bgClouds = ParallaxComponent(
      parallax: parallaxClouds,
      priority: -5,
    );
    add(bgClouds);

    Parallax parallaxTrees = await gameRef.loadParallax(
      [ParallaxImageData('background/treeline01.png')],
      baseVelocity: Vector2(25, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.none,
      alignment: Alignment.topCenter,
    );

    ParallaxComponent bgTrees = ParallaxComponent(
      parallax: parallaxTrees,
      priority: 0,
      // I don't understand why this puts it on the bottom, but it does
      position: Vector2(0, gameRef.size.y / 2 + 20),
    );
    add(bgTrees);
  }

  void _addPlayer() async {
    player = Player(
      name: 'Player1',
      isRotating: true,
    );
    player.position = Vector2(200, gameRef.size.y - 250);
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
