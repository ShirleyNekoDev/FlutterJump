import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';

import 'colors.dart';

bool DEBUG_MODE = true;

extension CanvasDrawDebugPosition on Canvas {
  void drawDebugPoint(Position position, Paint paint) {
    if (!DEBUG_MODE) return;
    drawLine(
      position.toOffset().translate(-3, -3),
      position.toOffset().translate(3, 3),
      paint,
    );
    drawLine(
      position.toOffset().translate(3, -3),
      position.toOffset().translate(-3, 3),
      paint,
    );
  }

  void drawDebugHLine(Position position, double width, Paint paint) {
    if (!DEBUG_MODE) return;
    var pointL = position.toOffset().translate(-width / 2, 0);
    var pointR = position.toOffset().translate(width / 2, 0);
    drawLine(pointL, pointR, paint);
    drawLine(pointL.translate(0, -3), pointL.translate(0, 3), paint);
    drawLine(pointR.translate(0, -3), pointR.translate(0, 3), paint);
  }
}

extension PositionComponentDrawDebug on PositionComponent {
  void drawDebug(Canvas canvas, Paint paint) {
    canvas.drawDebugPoint(toPosition(), paint);
    canvas.drawRect(toRect(), paint);
  }
}
