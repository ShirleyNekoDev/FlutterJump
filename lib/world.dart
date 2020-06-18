import 'dart:collection';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/position.dart';

import 'game.dart';
import 'player.dart';
import 'platform.dart';

class World extends Component {
  final FlutterJumpGame _game;

  final double gravity = -200.0; // px/s²
  
  /// camera cutoff over ground (0)
  /// e.g. lower end of world = out of screen
  double yCamCutoff = 0.0;
  Player player;
  /// Important: platforms are ordered by y coordinate with the lowest y being first!
  Queue<PlatformInstance> platforms = Queue();

  World(this._game) {
    print("New world");
    player = Player(this);
    _game.addLater(player);
    createPlatform(Position(0.48, 20));
    createPlatform(Position(0.65, 60));
    createPlatform(Position(0.43, 100));
  }

  @override
  void render(Canvas canvas) {
    // TODO: background
    renderPlatforms(canvas);
  }

  @override
  void update(double deltaTime) {
    // TODO: generate platforms
  }

  // local to global coordinate conversion
  // x: 0 - 1 => 0 - width
  // y: 0 (bottom ground) - height => camera position
  double localX2Global(double x) => x * _game.size.width;
  double localY2Global(double y) => _game.size.height - (y - yCamCutoff);
  Position local2GlobalPosition(double x, double y) => Position(
    localX2Global(x),
    localY2Global(y)
  );
  Position localPosition2GlobalPosition(Position position) => Position(
    localX2Global(position.x),
    localY2Global(position.y)
  );
  
  // global to local coordinate conversion
  double globalX2local(double x) => x / _game.size.width;

  void onPlayerControl(Offset globalPosition) {
    player.x = globalX2local(globalPosition.dx);
  }

  /// out of screen (lower end of world)
  bool isInDeathZone(double y) => y < yCamCutoff;
}
