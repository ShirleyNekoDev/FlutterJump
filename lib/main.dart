import 'package:flame/util.dart';
import 'package:flutter/material.dart';

import 'game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setPortraitUpOnly();

  FlutterJumpGame game = FlutterJumpGame();
  runApp(game.widget);
}
