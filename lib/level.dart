import 'dart:async';
import 'dart:math';
import 'package:caravan_tossing/caravan_tossing.dart';
import 'package:caravan_tossing/collision_block.dart';
import 'package:caravan_tossing/explosive_barrel.dart';
import 'package:caravan_tossing/force_bar.dart';
import 'package:caravan_tossing/player.dart';
import 'package:caravan_tossing/statusline.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';

class Level extends World
    with HasGameRef<CaravanTossing>, KeyboardHandler, CollisionCallbacks {
  late Player player;
  late SpriteAnimationComponent crow;
  late ParallaxComponent background;
  double bgSpeed = 0;
  Random random = Random();
  String statusBarText = 'Drücke rauf, runter und dann die Leertaste!';
  late Statusline statusLine;
  late Vector2 initPlayerPos;

  late TiledComponent levelTiles;
  List<CollisionBlock> collisionBlocks = [];
  List<SpriteComponent> itemBlocks = [];
  late double tilesOffsetY;
  late ForceBar forceBar;

// --- OVERRIDES

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;

    levelTiles = await TiledComponent.load(
      'level_01.tmx',
      Vector2.all(16),
    );
    levelTiles.priority = 10;
    tilesOffsetY = gameRef.size.y - levelTiles.size.y;
    // levelTiles.position.y = tilesOffsetY;
    add(levelTiles);

    initPlayerPos = Vector2(120, gameRef.size.y - 170);

    _addBackground();
    _addPlayer();
    _addCollisions();
    _addItems();

    statusLine = Statusline(text: statusBarText);
    add(statusLine);

    forceBar = ForceBar();
    //forceBar.enable();
    add(forceBar);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    crow.position.x += 2;
    crow.position.y += (random.nextDouble() - 0.5) * 2;
    bgSpeed = player.velocity.x * 0.1;
    levelTiles.position.x -= player.velocity.x * 0.3;

    for (final collisionBlock in collisionBlocks) {
      collisionBlock.position.x -= player.velocity.x * 0.3;
    }

    for (final itemBlock in itemBlocks) {
      itemBlock.position.x -= player.velocity.x * 0.3;
    }

    background.parallax?.baseVelocity = Vector2(bgSpeed, 0);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);
    final isSpaceKeyPressed = keysPressed.contains(LogicalKeyboardKey.space);

    if (player.canRotate) {
      if (isUpKeyPressed) {
        player.direction = -1; // Set direction to -1 for 'W' key
      } else if (isDownKeyPressed) {
        player.direction = 1; // Set direction to 1 for 'S' key
      } else if (isSpaceKeyPressed) {
        player.shootTheVan(forceBar.force);
        forceBar.disable();
      } else {
        player.direction = 0;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onGameResize(Vector2 size) async {
    tilesOffsetY = gameRef.size.y - levelTiles.size.y;
    levelTiles.position.y = tilesOffsetY;
    super.onGameResize(size);
  }

// --- PUBLIC

  void reset() {
    player.canRotate = true;
    player.isFlying = false;
    player.position = initPlayerPos;
    player.velocity = Vector2.zero();
    player.angle = 0;
    player.distanceVan = 0;
    player.distanceVanSum = 0;
    levelTiles.position.x = 0;
    background.parallax?.baseVelocity = Vector2.zero();
    forceBar.enable();
  }

// --- HELPERS

  void _addBackground() async {
    background = await gameRef.loadParallaxComponent(
      [
        ParallaxImageData('background/background01.png'),
        ParallaxImageData('background/mountains01.png'),
        ParallaxImageData('background/sky01.png'),
        //ParallaxImageData('background/treeline01.png'),
      ],
      baseVelocity: Vector2(bgSpeed, 0),
      velocityMultiplierDelta: Vector2(10, 0),
      repeat: ImageRepeat.repeatX,
      fill: LayerFill.height,
      alignment: Alignment.bottomLeft,
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
    player.position = initPlayerPos;
    add(player);
  }

  void _addCollisions() {
    final collisionLayer = levelTiles.tileMap.getLayer<ObjectGroup>('hitboxes');
    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        switch (collision.class_) {
          case 'background':
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y + tilesOffsetY),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            debugMode = true;
            block.priority = 11;
            add(block);
            break;
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }

  void _addItems() {
    final itemLayer = levelTiles.tileMap.getLayer<ObjectGroup>('hitboxes');
    if (itemLayer != null) {
      for (final item in itemLayer.objects) {
        switch (item.class_) {
          case 'explosives':
            final explosiveBarrel = ExplosiveBarrel(
              size: Vector2(item.width, item.height),
              position: Vector2(item.x, item.y + tilesOffsetY),
            );
            itemBlocks.add(explosiveBarrel);
            add(explosiveBarrel);
            break;
          default:
        }
      }
    }
  }
}
