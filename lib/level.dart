import 'dart:async';
import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:caravan_tossing/background_layer.dart';

class Level extends World with HasGameRef<CaravanTossing> {
  @override
  FutureOr<void> onLoad() {
    _addBackground();
    return super.onLoad();
  }

  void _addBackground() async {
    final BackgroundLayer layerBackground = BackgroundLayer(
      imagePath: 'background/background01.png',
      baseVelocity: Vector2(0, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height,
      alignmentY: 0,
      priority: -10,
      position: Vector2(0, 0),
    );
    final bgBackground = await layerBackground.createComponent(gameRef);

    final BackgroundLayer layerSky = BackgroundLayer(
      imagePath: 'background/sky01.png',
      baseVelocity: Vector2(15, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height,
      alignmentY: 0,
      priority: -5,
      position: Vector2(0, 0),
    );
    final bgSky = await layerSky.createComponent(gameRef);

    final BackgroundLayer layerTrees = BackgroundLayer(
      imagePath: 'background/treeline01.png',
      baseVelocity: Vector2(25, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.width,
      alignmentY: gameRef.size.y,
      priority: 0,
      position: Vector2(0, gameRef.size.y / 2 + 20),
    );
    final bgTrees = await layerTrees.createComponent(gameRef);

    addAll([bgBackground, bgSky, bgTrees]);
  }
}
