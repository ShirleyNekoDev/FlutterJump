import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';

import 'game.dart';

class Player extends PositionComponent {
  static final _color = Paint()..color = Color(0xFFFF0000);
  static final _size = 40.0;

  Player(this.gameRef) {
    anchor = Anchor.bottomCenter;
    this.width = _size;
    this.height = _size;
    this.y = 80;
    this.x = 0.5;
  }
  final FlutterJumpGame gameRef;

  @override
  void resize(Size size) {
    width = _size / size.width;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), _color);
  }

  @override
  void update(double deltaTime) {
  }
}
