import 'dart:collection';
import 'dart:ui';

import 'package:FlutterJump/utils/colors.dart';
import 'package:flame/position.dart';

import 'player.dart';
import 'utils/debug.dart';
import 'world.dart';

extension WorldPlatforms on World {
  void createPlatform(Position position, [PlatformPrototype prototype = null]) {
    var proto = (prototype == null) ? PlatformPrototype.DEFAULT : prototype;
    var platform = PlatformInstance(proto, position);
    platforms.add(platform);
  }

  void renderPlatforms(Canvas canvas) {
    platforms.forEach((instance) {
      var position = localPosition2GlobalPosition(instance.position);
      instance.prototype.render(canvas, position, this.localX2Global);
    });
  }

  CollisionAndFallDistance calculatePlayerCollisionsAndFallDistance(
      double playerDownSpeed) {
    var it = platforms.iterator;
    while (it.moveNext()) {
      var platform = it.current;
      if(!platform.isHOverlapping(player)) continue;

      double distance = platform.distanceTo(player);
      if (distance - playerDownSpeed <= 0) {
        return CollisionAndFallDistance(distance, platform);
      }
    }
    return CollisionAndFallDistance(playerDownSpeed);
  }
}

class CollisionAndFallDistance {
  final PlatformInstance collidedPlatform;
  final double fallDistance;

  CollisionAndFallDistance(this.fallDistance, [this.collidedPlatform = null]);

  bool hasCollision() => collidedPlatform != null;
}

class PlatformInstance {
  final PlatformPrototype prototype;
  Position position;

  PlatformInstance(this.prototype, this.position);

  double distanceTo(Player player) => player.y - position.y;

  bool isHOverlapping(Player player) =>
    player.x <= position.x + prototype.width && player.x + player.width >= position.x;
}

class PlatformPrototype {
  static final _color = Paint()..color = Color(0xFF00FF00);
  static const _width = 0.1; // 1/10th of the screen width
  static const _height = 4.0;

  static final DEFAULT = PlatformPrototype();

  final double width;
  final double height;

  PlatformPrototype([this.width = _width, this.height = _height]);

  void render(Canvas canvas, Position position,
      double Function(double) local2GlobalWidth) {
    var width = local2GlobalWidth(this.width);
    var rect = Rect.fromCenter(
      center: Offset(position.x, position.y + height / 2),
      width: width,
      height: height,
    );
    canvas.drawRect(rect, _color);
    canvas.drawDebugPoint(position, PAINT_RED);
    canvas.drawDebugHLine(position, width, PAINT_RED);
  }

  void onPlayerCollided(Player player) {}
}
