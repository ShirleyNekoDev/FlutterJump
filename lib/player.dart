import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';

import 'utils/debug.dart';
import 'world.dart';

class Player extends PositionComponent {
  static final _color = Paint()..color = Color(0xFFFFAA00);
  static const _size = 40.0;

  final World _world;

  bool alive = true;
  double ySpeed = 0.0;

  Player(this._world) {
    anchor = Anchor.bottomCenter;
    width = _size;
    height = _size;
    y = 80;
    x = 0.5;
  }

  @override
  void resize(Size size) {
    width = _size / size.width;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), _color);
    drawDebug(canvas);
  }

  @override
  void update(double deltaTime) {
    if (alive) {
      move(deltaTime);
      deathCheck();
    }
  }

  void move(double deltaTime) {
    ySpeed += deltaTime * _world.gravity;
    y += deltaTime * ySpeed;
    _world.calculatePlayerCollisionsAndFallDistance(deltaTime * ySpeed);
  }

  void deathCheck() {
    if (_world.isInDeathZone(y)) {
      print("you died");
      alive = false;
    }
  }
}
