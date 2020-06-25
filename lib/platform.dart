import 'dart:math';
import 'dart:ui';

import 'package:FlutterJump/utils/colors.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';

import 'player.dart';
import 'utils/debug.dart';
import 'world.dart';

extension WorldPlatforms on World {
  void createPlatform(Position position, [PlatformPrototype prototype]) {
    var proto = (prototype == null) ? PlatformPrototype.DEFAULT : prototype;
    var platform = PlatformInstance(proto, position);
    print("create new platform at $position");
    platforms.add(platform);
  }

  void renderPlatforms(Canvas canvas) {
    platforms.forEach((instance) {
      var position = localPosition2GlobalPosition(instance.position);
      instance.prototype.render(canvas, position, this.localWidth2Global);
    });
  }

  void removeOldPlatforms() {
    while (platforms.first.position.y < yCamCutoff) {
      platforms.removeFirst();
    }
  }

  void generateNewPlatforms() {
    final highestPlatformY = platforms.last.position.y;
    print("top platform: $highestPlatformY");
    if (yCamTopPosition - highestPlatformY > platformDistance.min) {
      createPlatform(
        Position(
          platformRandom.nextDouble(),
          highestPlatformY + platformDistance.random(platformRandom),
        ),
        selectPlatformType(),
      );
    }
  }

  PlatformPrototype selectPlatformType() =>
      PlatformTypeDefinitionsWithWeight.selectRandomType(platformRandom);
}

class PlatformInstance {
  final PlatformPrototype prototype;
  Position position;

  PlatformInstance(this.prototype, this.position);

  double distanceTo(Player player) => player.y - position.y;

  bool isHOverlapping(Player player) =>
      player.x <= position.x + prototype.width &&
      player.x + player.width >= position.x;

  void onPlayerCollided(Player player) => prototype.onPlayerCollided(player);
}

class PlatformTypeDefinitionsWithWeight {
  static final DEFINITIONS = [
    PlatformTypeDefinitionsWithWeight._(PlatformPrototype(), 15),
    PlatformTypeDefinitionsWithWeight._(ThinPlatformPrototype(), 5),
    PlatformTypeDefinitionsWithWeight._(JumpboostPlatformPrototype(), 1),
  ];

  static PlatformPrototype selectRandomType(Random random) {
    final totalWeight = DEFINITIONS
        .map((def) => def.weight)
        .reduce((value, element) => value + element);

    final r = random.nextInt(totalWeight);
    var sum = 0;
    for (final def in DEFINITIONS) {
      sum += def.weight;
      if (sum > r) {
        return def.prototype;
      }
    }
    return DEFINITIONS.last.prototype;
  }

  final PlatformPrototype prototype;
  final int weight;

  const PlatformTypeDefinitionsWithWeight._(this.prototype, this.weight);
}

class PlatformPrototype {
  static final _paint = Paint()..color = Color(0xFF00FF00);
  static const _width = 0.1; // 1/10th of the screen width
  static const _height = 4.0;

  static final DEFAULT = PlatformPrototype();

  final double width;
  final double height;
  final Paint paint;

  PlatformPrototype({
    this.width = _width,
    this.height = _height,
    Paint paint,
  }) : this.paint = paint ?? _paint;

  void render(Canvas canvas, Position position,
      double Function(double) localWidth2Global) {
    var width = localWidth2Global(this.width);
    var rect = Rect.fromCenter(
      center: Offset(position.x, position.y + height / 2),
      width: width,
      height: height,
    );
    canvas.drawRect(rect, paint);
    canvas.drawDebugPoint(position, PAINT_RED);
    canvas.drawDebugHLine(position, width, PAINT_RED);
  }

  void onPlayerCollided(Player player) {
    player.jump();
  }
}

class JumpboostPlatformPrototype extends PlatformPrototype {
  final jumpMultiplier;

  JumpboostPlatformPrototype([
    this.jumpMultiplier = 2.0,
  ]) : super(paint: Paint()..color = Color(0xFF007DD7));

  @override
  void onPlayerCollided(Player player) {
    player.jump(jumpMultiplier);
  }
}

class ThinPlatformPrototype extends PlatformPrototype {
  ThinPlatformPrototype() : super(width: 0.05);
}
