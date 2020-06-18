import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';

import '../game.dart';
import 'colors.dart';

bool DEBUG_MODE = true;

extension CanvasDrawDebugPosition on Canvas {
  void drawDebugPoint(Position position, Paint paint) {
    if(!DEBUG_MODE) return;
    var xPos = position.x / APP_WIDTH;
    drawLine(
      position.toOffset().translate(-3 * xPos, -3),
      position.toOffset().translate(3 * xPos, 3),
      // position.toOffset().translate(-3, -3),
      // position.toOffset().translate(3, 3),
      paint
    );
    drawLine(
      position.toOffset().translate(3 * xPos, -3),
      position.toOffset().translate(-3 * xPos, 3),
      // position.toOffset().translate(3, -3),
      // position.toOffset().translate(-3, 3),
      paint
    );
  }
}

extension PositionComponentDrawDebug on PositionComponent {
  void drawDebug(Canvas canvas) {
    drawDebugWithCustonPaint(canvas, PAINT_RED);
  }

  void drawDebugWithCustonPaint(Canvas canvas, Paint paint) {
    canvas.drawDebugPoint(toPosition(), paint);
    canvas.drawRect(toRect(), paint);
  }
}