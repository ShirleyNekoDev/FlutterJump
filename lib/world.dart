import 'dart:collection';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';

import 'game.dart';
import 'player.dart';
import 'platform.dart';

class World extends Component {
  final FlutterJumpGame _game;

  final double gravity = 200.0; // px/s²
  
  // camera cutoff
  double yPosition = 0.0;
  Player player;
  // Important: platforms are ordered by y coordinate with the highest y (lowest on screen) being first!
  Queue<Platform> platforms = Queue();

  World(this._game) {
    print("New world");
    player = Player(this);
    _game.addLater(player);
    addPlatform(Position(0.5, 160));
  }

  void addPlatform(Position position) {
    var platform = Platform(position);
    platforms.add(platform);
    _game.addLater(platform);
  }

  @override
  void render(Canvas canvas) {
    // TODO: background
  }

  @override
  void update(double deltaTime) {
    // TODO: generate platforms
  }

  // Rect localToGlobalRect(Rect rect) {
  //   return Rect.fromCenter(
  //     Offset()
  //   )
  // }

  bool isInDeathZone(double y) => y < yPosition;

  CollisionAndFallDistance calculatePlayerCollisionsAndFallDistance(double playerYSpeed) {
    // var it = obj.iterator;
    // while (it.moveNext()) {
    //   use(it.current);
    // }
    return CollisionAndFallDistance();
  }
}

class CollisionAndFallDistance {

}