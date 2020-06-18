import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'world.dart';
import 'utils/debug.dart';

double APP_WIDTH = 0.0;

class FlutterJumpGame extends BaseGame with HorizontalDragDetector {
  @override
  bool debugMode() => DEBUG_MODE;

  World _world;

  void initialize() async {
    resize(await Flame.util.initialDimensions());
  }

  FlutterJumpGame() {
    initialize();
    this._world = World(this);
    addLater(_world);
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(size.width, 1);
    super.render(canvas);
  }

  @override
  void resize(Size size) {
    APP_WIDTH = size.width;
    super.resize(size);
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    var horizontalPos = details.localPosition.dx / size.width;
    print("horizontal drag update $horizontalPos");
    _world.player.x = horizontalPos;
  }
}
