import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Statusline extends TextComponent {
  Statusline({super.text});

  final TextStyle _statusBarTextStyle = TextStyle(
    fontSize: 25,
    color: BasicPalette.white.color,
  );

  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.topLeft;
    position = Vector2(10, 10);
    priority = 100;
    textRenderer = TextPaint(style: _statusBarTextStyle);

    return super.onLoad();
  }
}
