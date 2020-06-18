import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/cupertino.dart';

import 'world.dart';
import 'utils/debug.dart';

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
  void onHorizontalDragStart(DragStartDetails details) {
    _world.onPlayerControl(details.localPosition);
  }

  @override
  void onHorizontalDragUpdate(DragUpdateDetails details) {
    _world.onPlayerControl(details.localPosition);
  }
}
