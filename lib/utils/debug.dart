import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';


bool DEBUG_MODE = true;
final TextConfig _debugTextConfig = TextConfig(
  fontSize: 12.0,
  color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
);

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
    final pointL = position.toOffset().translate(-width / 2, 0);
    final pointR = position.toOffset().translate(width / 2, 0);
    drawLine(pointL, pointR, paint);
    drawLine(pointL.translate(0, -3), pointL.translate(0, 3), paint);
    drawLine(pointR.translate(0, -3), pointR.translate(0, 3), paint);
  }

  void drawDebugText(Position position, String text, [double fontSize = 48]) {
    if (!DEBUG_MODE) return;
    _debugTextConfig.render(this, text, position);
  }
}

extension PositionComponentDrawDebug on PositionComponent {
  void drawDebug(Canvas canvas, Paint paint) {
    if (!DEBUG_MODE) return;
    canvas.drawDebugPoint(toPosition(), paint);
    canvas.drawRect(toRect(), paint);
  }
}
