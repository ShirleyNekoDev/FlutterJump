import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'platform.dart';
import 'world.dart';

class FlutterJumpGame extends BaseGame with HorizontalDragDetector {
  @override
  bool debugMode() => true;

  World _world;

  List<Platform> _platforms = List();

  FlutterJumpGame() {
    this._world = World(this);
    add(_world);
  }

  @override
  void render(Canvas canvas) {
    canvas.scale(size.width, 1);
    super.render(canvas);
  }

  @override
  void onHorizontalDragStart(DragStartDetails details) {
    print("horizontal drag start ${details.localPosition}");
  }
  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    var horizontalPos = details.localPosition.dx / size.width;
    print("horizontal drag update $horizontalPos");
    _world.player.x = horizontalPos;
  }

  // @override
  // void onPanDown(DragDownDetails details) {
  //   print("pan down ${details.localPosition}");
  // }
  // @override
  // void onPanStart(DragStartDetails details) {
  //   print("pan start ${details.localPosition}");
  // }
  // @override
  // void onPanUpdate(DragUpdateDetails details) {
  //   print("pan update ${details.localPosition}");
  //   print("pan update ${details.primaryDelta}");
  // }
}
