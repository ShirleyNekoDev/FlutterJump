import 'dart:ui';

import 'package:flame/components/component.dart';

import 'game.dart';
import 'player.dart';

class World extends Component {
  final FlutterJumpGame _gameRef;

  final Player player;

  World(this._gameRef) : player = Player(_gameRef) {
    _gameRef.addLater(player);
    print("added player");
  }

  @override
  void render(Canvas canvas) {
  }

  @override
  void update(double deltaTime) {
  }
}
