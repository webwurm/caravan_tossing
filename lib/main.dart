import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  CaravanTossing game = CaravanTossing();
  // Sicherstellen, dass während Developement nicht immer komplett neu geladen werden muss
  runApp(GameWidget(game: kDebugMode ? CaravanTossing() : game));
}
