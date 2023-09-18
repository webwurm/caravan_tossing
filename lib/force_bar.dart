import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:num_remap/num_remap.dart';

class ForceBar extends RectangleComponent {
  ForceBar({
    super.position,
    super.size,
  });

  late RectangleComponent forceBar;
  late RectangleComponent forceBarBg;
  double velocity = 125;
  double force = 0.0;

  @override
  FutureOr<void> onLoad() {
    priority = 30;
    forceBarBg = RectangleComponent(
        anchor: Anchor.bottomLeft,
        size: Vector2(150, 30),
        paint: Paint()
          ..color = Colors.black
          ..strokeWidth = 2
          ..style = PaintingStyle.fill);
    forceBarBg.position = Vector2(-2, 122);
    add(forceBarBg);

    forceBar = RectangleComponent(
        anchor: Anchor.bottomLeft,
        size: Vector2(0, 26),
        position: Vector2(0, 120),
        paint: Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.fill);

    add(forceBar);
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
}
