import 'dart:collection';
import 'dart:math';
import 'dart:ui';

import 'package:FlutterJump/utils/double_range.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';

import 'game.dart';
import 'player.dart';
import 'platform.dart';
import 'utils/debug.dart';
import 'utils/colors.dart';

final TextConfig scoreTextConfig = TextConfig(
  fontSize: 14.0,
  color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF),
);

class World extends Component {
  final FlutterJumpGame _game;

  /// in seconds since world creation
  double globalTime = 0;

  final double gravity = -200.0; // px/s²

  Player player;

  /// Important: platforms are ordered by y coordinate with the lowest y being first!
  Queue<PlatformInstance> platforms = Queue();
  final DoubleRange platformDistance = DoubleRange(15, 60);
  final Random platformRandom = Random(1);

  /// camera cutoff over ground (0)
  /// e.g. lower end of world = out of screen
  double yCamCutoff = 0.0;

  /// start scrolling if player position is over this position
  double get yCamScrollPosition =>
      yCamCutoff + (_game.size.height - player.height) / 2;
  double get yCamTopPosition => yCamCutoff + (_game.size?.height ?? 0);

  /// offset in pixels, used for screenshake
  double xCamOffset = 0.0;

  double screenshakeTime = 0;
  final double screenshakeFrequency = 50.0;
  final double screenshakeAmplitude = 0.005;
  final double screenshakeDamping = 0.01;

  World(this._game) {
    print("New world");
    player = Player(this);
    _game.add(
        player); // Important: add player before world itself because of update order
    createPlatform(Position(0.5, 10));
    generateNewPlatforms();
  }

  @override
  void render(Canvas canvas) {
    // TODO: background
    renderPlatforms(canvas);
    canvas.drawDebugHLine(local2GlobalPosition(0.5, yCamScrollPosition),
        _game.size.width, PAINT_RED);
    canvas.drawDebugText(
      Position(10, 10),
      "Global Time: ${globalTime.toStringAsFixed(2)}\n"
      "Player Y: ${player.y.toInt()}\n"
      "Altitude: ${yCamCutoff.toInt()}\n",
    );
    scoreTextConfig.render(canvas, "Score: ${yCamCutoff.toInt()}", Position(10, 10));
  }

  @override
  void update(double deltaTime) {
    if (!player.alive) return;
    scrollCamera();
    generateNewPlatforms();

    globalTime += deltaTime;
    applyScreenshake();
  }

  void scrollCamera() {
    final camYOffset = player.y - yCamScrollPosition;
    if (camYOffset > 0) {
      yCamCutoff += camYOffset;
      removeOldPlatforms();
    }
  }

  void startScreenshake() {
    screenshakeTime = globalTime;
  }

  void applyScreenshake() {
    final delta = globalTime - screenshakeTime;
    final damping = pow(screenshakeDamping, delta);
    final shake = sin(screenshakeTime + delta * screenshakeFrequency);
    xCamOffset = shake * damping * screenshakeAmplitude;
  }

  // local to global coordinate conversion
  // x: 0 - 1 => 0 - width
  // y: 0 (bottom ground) - height => camera position
  double localX2Global(double x) => (x + xCamOffset) * _game.size.width;
  double localWidth2Global(double w) => w * _game.size.width;
  double localY2Global(double y) => _game.size.height - (y - yCamCutoff);

  Position local2GlobalPosition(double x, double y) =>
      Position(localX2Global(x), localY2Global(y));
  Position localPosition2GlobalPosition(Position position) =>
      Position(localX2Global(position.x), localY2Global(position.y));

  // global to local coordinate conversion
  double globalX2local(double x) => x / _game.size.width;

  void onPlayerControl(Offset globalPosition) {
    player.onHorizontalControl(globalX2local(globalPosition.dx));
  }

  /// out of screen (lower end of world)
  bool isInDeathZone(double y) => y < yCamCutoff;
}
