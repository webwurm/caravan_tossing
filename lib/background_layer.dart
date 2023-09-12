import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class BackgroundLayer {
  final String imagePath;
  final Vector2 baseVelocity;
  final ImageRepeat repeat;
  final LayerFill fill;
  final double alignmentY;
  final int priority;
  final Vector2 position;

  BackgroundLayer({
    required this.imagePath,
    required this.baseVelocity,
    required this.repeat,
    required this.fill,
    required this.alignmentY,
    this.priority = 0,
    required this.position,
  });

  Future<ParallaxComponent> createComponent(Game gameRef) async {
    Parallax parallax = await gameRef.loadParallax(
      [ParallaxImageData(imagePath)],
      baseVelocity: baseVelocity,
      repeat: repeat,
      fill: fill,
      alignment: Alignment.topCenter,
    );

    return ParallaxComponent(
      parallax: parallax,
      priority: priority,
      position: Vector2(position.x, 20),
    );
  }
}
