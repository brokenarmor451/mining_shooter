import 'dart:async';
import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute, Matrix4;
import 'package:mining_shooter/audio/audio_manager.dart';
import 'package:mining_shooter/save/save_manager.dart';
import 'package:mining_shooter/screen/battle_screen.dart';
import 'package:mining_shooter/screen/battle_select_screen.dart';
import 'package:mining_shooter/screen/inventory_screen.dart';
import 'package:mining_shooter/screen/main_menu_screen.dart';
import 'package:mining_shooter/screen/mining_screen.dart';
import 'package:mining_shooter/screen/mining_select_screen.dart';
import 'package:mining_shooter/screen/upgrade_screen.dart';
import 'package:mining_shooter/ui/death_dialog.dart';
import 'package:mining_shooter/ui/insufficient_item_dialog.dart';
import 'package:mining_shooter/ui/menu_dialog.dart';
import 'package:mining_shooter/ui/mining_hud.dart';
import 'package:mining_shooter/ui/settings_dialog.dart';

class MiningShooter extends FlameGame with HasCollisionDetection {
  late TexturePackerAtlas _atlas;
  TexturePackerAtlas get atlas => _atlas;

  late final RouterComponent _router;
  RouterComponent get router => _router;

  late final SaveManager _saveManager;
  SaveManager get saveManager => _saveManager;

  late final AudioManager _audioManager;
  AudioManager get audioManager => _audioManager;

  static const pixelsPerUnit = 16.0;

  double _timeSinceLastSave = 0;

  MiningShooter()
    : super(
        camera: CameraComponent.withFixedResolution(width: 9, height: 16)
          ..viewfinder.anchor = Anchor.topLeft,
      );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await _initAudio();

    await _initAtlas();

    await _initSaveManager();

    await _initRoutes();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _timeSinceLastSave += dt;

    if (_timeSinceLastSave >= 10) {
      saveManager.saveAll();
      _timeSinceLastSave = 0;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    final scale = (camera.viewport as FixedResolutionViewport).scale;
    final offset = camera.viewport.position;

    (camera.viewport as FixedResolutionViewport).scale.setFrom(
      Vector2(scale.x.roundToDouble(), scale.y.roundToDouble()),
    );

    camera.viewport.position = Vector2(
      offset.x.roundToDouble(),
      offset.y.roundToDouble(),
    );
  }

  Future<void> _initRoutes() async {
    final routes = <String, Route>{
      'Mining Area 1': WorldRoute(MiningArea1.new, maintainState: false),
      'Mining Area 2': WorldRoute(MiningArea2.new, maintainState: false),
      'Mining Area 3': WorldRoute(MiningArea3.new, maintainState: false),
      'Battle Area 1': WorldRoute(BattleArea1.new, maintainState: false),
      'Battle Area 2': WorldRoute(BattleArea2.new, maintainState: false),
      'Battle Area 3': WorldRoute(BattleArea3.new, maintainState: false),

      'Main Menu': OverlayRoute((context, game) {
        return MainMenuScreen(game: this);
      }),

      'Upgrade': OverlayRoute((context, game) {
        return UpgradeScreen(game: this);
      }),

      'Battle Select': OverlayRoute((context, game) {
        return BattleSelectScreen(game: this);
      }),

      'Mining Select': OverlayRoute((context, game) {
        return MiningSelectScreen(game: this);
      }),
    };

    _router = RouterComponent(initialRoute: 'Main Menu', routes: routes);

    await add(_router);
  }

  Future<void> _initAtlas() async {
    _atlas = await atlasFromAssets('graphics.atlas');
  }

  Future<void> _initSaveManager() async {
    _saveManager = SaveManager();

    await _saveManager.load();
  }

  Future<void> _initAudio() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      _audioManager = AudioManager(); // You can create a mock version
      return;
    }

    _audioManager = AudioManager();
    await _audioManager.load();
  }

  @override
  void onRemove() {
    super.onRemove();

    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }

    audioManager.soloud.disposeAllSources();
  }
}

void main() {
  final game = MiningShooter();

  runApp(GameScreen(game: game));
}

class GameScreen extends StatefulWidget {
  final MiningShooter _game;

  GameScreen({required MiningShooter game}) : _game = game;

  @override
  State<StatefulWidget> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GameWidget(
        game: widget._game,
        overlayBuilderMap: <String, OverlayWidgetBuilder>{
          'Death Dialog': (context, game) =>
              DeathDialog(game: game as MiningShooter),
          'Menu Dialog': (contex, game) =>
              MenuDialog(game: game as MiningShooter),

          'Settings Dialog': (contex, game) =>
              SettingsDialog(game: game as MiningShooter),

          'Insufficient Item Dialog': (contex, game) =>
              InsufficientItemDialog(game: game as MiningShooter),

          'Mining Hud': (context, game) =>
              MiningHud(game: game as MiningShooter),

          'Inventory': (context, game) =>
              InventoryScreen(game: game as MiningShooter),
        },
      ),
    );
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_myInterceptor);
    super.dispose();
  }

  bool _myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }
}
