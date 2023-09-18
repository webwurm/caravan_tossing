import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/game_over.dart';
import 'package:caravan_tossing/main_menu.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  //CaravanTossing game = CaravanTossing();
  // Sicherstellen, dass während Developement nicht immer komplett neu geladen werden muss
  runApp(GameWidget<CaravanTossing>.controlled(
    gameFactory: CaravanTossing.new,

    // old code:
    //game: kDebugMode ? CaravanTossing() : game,
    //game: game,

    // Overlays hinzufügen
    overlayBuilderMap: {
      'MainMenu': (_, game) => MainMenu(game: game),
      'GameOver': (_, game) => GameOver(game: game),
    },
    initialActiveOverlays: const ['MainMenu'],
  ));
}
