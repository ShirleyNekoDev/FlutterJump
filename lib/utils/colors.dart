
import 'dart:ui';

final Paint PAINT_RED = _createPaint(255, 0, 0);
final Paint PAINT_GREEN = _createPaint(0, 255, 0);
final Paint PAINT_BLUE = _createPaint(0, 0, 255);

Paint _createPaint(int red, int green, int blue) {
  return Paint()
    ..color = Color.fromARGB(0xFF, red, green, blue)
    ..isAntiAlias = false
    ..style = PaintingStyle.stroke;
}
