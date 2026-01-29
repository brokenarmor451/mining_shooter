import 'dart:async';
import 'dart:io';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:mining_shooter/entity/particle_effect.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/tools/pickaxe.dart';

abstract class Ore extends SpriteComponent
    with HasGameReference<MiningShooter>, TapCallbacks {
  final String _name;

  final Pickaxe _pickaxe;

  final List<Vector2> _tileList;

  final _health = 200.0;

  late double _currentHealth;

  double get currentHealth => _currentHealth;

  bool _startDig = false;

  Ore({
    required String name,
    required List<Vector2> tileList,
    required Pickaxe pickaxe,
    super.position,
  }) : _name = name,
       _tileList = tileList,
       _pickaxe = pickaxe,
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
  void update(double dt) {
    if (_startDig == true && _pickaxe.currentTile != this) {
      _startDig = false;
    }

    if (_startDig) {
      _currentHealth -= _pickaxe.data.damage * dt;

      if (_currentHealth <= 0.0) {
        onDigged();
      } else {
        opacity = _currentHealth / _health;
      }
    }
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

  void _stopDigSound() async {
    if (game.audioManager.digSoundHandle != null) {
      await game.audioManager.soloud.stop(game.audioManager.digSoundHandle!);

      game.audioManager.digSoundHandle = null;
    }
  }

  void _playOreCollectSound() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }

    if (game.saveManager.settings.soundOn) {
      game.audioManager.digSoundHandle = await game.audioManager.soloud.play(
        game.audioManager.itemCollectSoundSource,
      );
    }
  }

  @mustCallSuper
  void onDigged() {
    _startDig = false;
    _tileList.remove(position);
    _pickaxe.stop();
    _playOreCollectSound();
    _stopDigSound();

    game.world.add(
      RewardParticleEffect(
        itemAmount: 1,
        itemName: _name,
        position: Vector2(4.5, 1),
      ),
    );

    removeFromParent();
  }

  @override
  void onRemove() {
    super.onRemove();

    _stopDigSound();
  }
}

class IronOre extends Ore {
  @override
  final _health = 200.0;

  IronOre({
    super.position,
    required List<Vector2> tileList,
    required Pickaxe pickaxe,
  }) : super(name: 'iron-ore', tileList: tileList, pickaxe: pickaxe) {}

  @override
  void onDigged() {
    super.onDigged();
    game.saveManager.inventory.addItem('iron-ore', 'Iron Ore', 1);
  }
}

class GoldOre extends Ore {
  @override
  final _health = 300.0;

  GoldOre({
    super.position,
    required List<Vector2> tileList,
    required Pickaxe pickaxe,
  }) : super(name: 'gold-ore', tileList: tileList, pickaxe: pickaxe) {}

  @override
  void onDigged() {
    super.onDigged();
    game.saveManager.inventory.addItem('gold-ore', 'Gold Ore', 1);
  }
}

class AmethystOre extends Ore {
  @override
  final _health = 400.0;

  AmethystOre({
    super.position,
    required List<Vector2> tileList,
    required Pickaxe pickaxe,
  }) : super(name: 'amethyst-ore', tileList: tileList, pickaxe: pickaxe) {}

  @override
  void onDigged() {
    super.onDigged();
    game.saveManager.inventory.addItem('amethyst-ore', 'Amethyst Ore', 1);
  }
}

class DiamondOre extends Ore {
  @override
  final _health = 500.0;

  DiamondOre({
    super.position,
    required List<Vector2> tileList,
    required Pickaxe pickaxe,
  }) : super(name: 'diamond-ore', tileList: tileList, pickaxe: pickaxe) {}

  @override
  void onDigged() {
    super.onDigged();
    game.saveManager.inventory.addItem('diamond-ore', 'Diamond Ore', 1);
  }
}
