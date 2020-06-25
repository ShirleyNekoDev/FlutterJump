import 'dart:ui';

import 'package:FlutterJump/utils/colors.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';

import 'utils/debug.dart';
import 'world.dart';
import 'collisions.dart';

class Player extends PositionComponent {
  static final _color = Paint()..color = Color(0xFFFFB000);
  static const _size = 0.1; // 1/10th of the screen width
  static const _jumpSpeed = 200.0;

  final World _world;

  bool alive = true;
  double ySpeed = _jumpSpeed;

  Player(this._world, [double yPos = 80]) {
    width = _size;
    height = _size;
    y = yPos;
    x = 0.5;
  }

  @override
  void resize(Size size) {
    height = _size * size.width;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), _color);
    drawDebug(canvas, PAINT_RED);
  }

  @override
  Position toPosition() => _world.local2GlobalPosition(x, y);

  @override
  Rect toRect() => Rect.fromLTWH(
        _world.localX2Global(x - width / 2),
        _world.localY2Global(y + height),
        _world.localWidth2Global(width),
        height,
      );

  @override
  void update(double deltaTime) {
    if (alive) {
      physicsMove(deltaTime);
      deathCheck();
    }
    super.update(deltaTime);
  }

  void onHorizontalControl(double newX) {
    if(alive) {
      x = newX;
    }
  }

  void physicsMove(double deltaTime) {
    ySpeed += deltaTime * _world.gravity;
    if (ySpeed < 0) {
      final collision =
          _world.calculatePlayerCollisionsAndFallDistance(deltaTime * -ySpeed);
      y -= collision.fallDistance;
      if (collision.hasCollision) {
        collision.collidedPlatform.onPlayerCollided(this);
        _world.startScreenshake();
      }
    } else {
      y += deltaTime * ySpeed;
    }
  }

  void jump([double jumpMultiplier = 1]) {
    ySpeed = jumpMultiplier * _jumpSpeed;
  }

  void deathCheck() {
    if (_world.isInDeathZone(y)) {
      print("you died");
      alive = false;
    }
  }
}
