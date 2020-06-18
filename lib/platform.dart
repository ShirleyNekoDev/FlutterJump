
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';

import 'player.dart';
import 'utils/debug.dart';

class Platform extends PositionComponent {
  static final _color = Paint()..color = Color(0xFF00FF00);
  static const _width = 50.0;
  static const _height = 10.0;

  Platform(Position position) {
    anchor = Anchor.topCenter;
    this.width = _width;
    this.height = _height;
    this.x = position.x;
    this.y = position.y;
  }

  @override
  void resize(Size size) {
    width = _width / size.width;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(toRect(), _color);
    drawDebug(canvas);
  }

  void onPlayerCollided(Player player) {
    
  }
}
