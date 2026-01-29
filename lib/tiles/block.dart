import 'dart:async';
import 'dart:io';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/tools/pickaxe.dart';

class Block extends SpriteComponent
    with HasGameReference<MiningShooter>, TapCallbacks, PointerMoveCallbacks {
  final String _name;

  final Pickaxe _pickaxe;

  final List<Vector2> _tileList;

  final _health = 100.0;

  late double _currentHealth;

  bool _startDig = false;

  Block({
    required String name,
    required List<Vector2> tileList,
    required Pickaxe pickaxe,
    super.position,
  }) : _name = name,
       _pickaxe = pickaxe,
       _tileList = tileList,
       super(
         size: Vector2.all(16 / MiningShooter.pixelsPerUnit),
         anchor: Anchor.topLeft,
       ) {
    _currentHealth = _health;
  }
  @override
  FutureOr<void> onLoad() async {
    sprite = game.atlas.findSpriteByName(_name);
    add(RectangleHitbox());
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_blocked()) {
      _pickaxe.stop();
      _pickaxe.start(
        position.clone()..add(Vector2.all(8.0 / MiningShooter.pixelsPerUnit)),
        this,
      );

      _playDigSound();

      _startDig = true;
    }
  }

  @override
  void update(double dt) {
    if (_startDig == true && _pickaxe.currentTile != this) {
      _startDig = false;
    }

    if (_startDig) {
      _currentHealth -= _pickaxe.data.damage * dt;

      if (_currentHealth <= 0.0) {
        _tileList.remove(position);
        _startDig = false;
        _pickaxe.stop();
        _stopDigSound();
        removeFromParent();
      } else {
        opacity = _currentHealth / _health;
      }
    }
  }

  @override
  void onRemove() {
    super.onRemove();
    _stopDigSound();
  }

  bool _blocked() {
    if (position.y == 13 && position.x == 8) {
      return (_tileList.contains(Vector2(position.x - 1, position.y)) &&
          _tileList.contains(Vector2(position.x, position.y - 1)));
    }

    if (position.y == 13 && position.x == 0) {
      return (_tileList.contains(Vector2(position.x + 1, position.y)) &&
          _tileList.contains(Vector2(position.x, position.y - 1)));
    }

    if (position.y == 13) {
      return (_tileList.contains(Vector2(position.x - 1, position.y)) &&
          _tileList.contains(Vector2(position.x + 1, position.y)) &&
          _tileList.contains(Vector2(position.x, position.y - 1)));
    }

    if (position.x == 0 && position.y > 0) {
      return (_tileList.contains(Vector2(position.x, position.y - 1)) &&
          _tileList.contains(Vector2(position.x + 1, position.y)) &&
          _tileList.contains(Vector2(position.x, position.y + 1)));
    }

    if (position.x == 8 && position.y > 0) {
      return (_tileList.contains(Vector2(position.x, position.y - 1)) &&
          _tileList.contains(Vector2(position.x - 1, position.y)) &&
          _tileList.contains(Vector2(position.x, position.y + 1)));
    }

    return (_tileList.contains(Vector2(position.x - 1, position.y)) &&
        _tileList.contains(Vector2(position.x + 1, position.y)) &&
        _tileList.contains(Vector2(position.x, position.y - 1)) &&
        _tileList.contains(Vector2(position.x, position.y + 1)));
  }

  void _playDigSound() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }

    if (!game.saveManager.settings.soundOn) return;

    if (game.audioManager.digSoundHandle != null) {
      return; // already playing
    }

    game.audioManager.digSoundHandle = await game.audioManager.soloud.play(
      game.audioManager.digSoundSource,
      looping: true,
    );
  }

  Future<void> _stopDigSound() async {
    if (game.audioManager.digSoundHandle != null) {
      await game.audioManager.soloud.stop(game.audioManager.digSoundHandle!);
      game.audioManager.digSoundHandle = null;
    }
  }
}

class Stone extends Block {
  Stone({
    super.position,
    required Pickaxe pickaxe,
    required List<Vector2> tileList,
  }) : super(name: 'stone-block', pickaxe: pickaxe, tileList: tileList);
}
