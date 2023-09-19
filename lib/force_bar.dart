import 'dart:async';

import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:num_remap/num_remap.dart';

class ForceBar extends RectangleComponent with HasGameRef<CaravanTossing> {
  ForceBar();

  late RectangleComponent forceBar;
  late RectangleComponent forceBarBg;
  double initVelocity = 125;
  double velocity = 0;
  double force = 0.0;

  @override
  FutureOr<void> onLoad() {
    priority = 30;
    velocity = initVelocity;
    forceBarBg = RectangleComponent(
        anchor: Anchor.bottomLeft,
        size: Vector2(120, 20),
        position: Vector2(55, game.size.y - 80),
        paint: Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.fill);
    //forceBarBg.position = Vector2(-2, 122);

    forceBar = RectangleComponent(
        anchor: Anchor.bottomLeft,
        size: Vector2(0, 16),
        position: Vector2(forceBarBg.position.x + 2, forceBarBg.position.y - 2),
        paint: Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.fill);

    enable();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    forceBar.size.x += velocity * dt;
    force = forceBar.size.x;
    force = force.remap(0, forceBarBg.size.x - 4, 1, 100);
    if ((forceBar.size.x <= 0) || (forceBar.size.x >= forceBarBg.size.x - 4)) {
      velocity *= -1;
    }

    super.update(dt);
  }

  void enable() {
    velocity = initVelocity;
    forceBar.size.x = 0;
    addAll([forceBarBg, forceBar]);
  }

  void disable() {
    velocity = 0;
    remove(forceBar);
    remove(forceBarBg);
  }
}
