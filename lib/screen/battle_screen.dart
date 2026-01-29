import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:mining_shooter/entity/asteroid.dart';
import 'package:mining_shooter/entity/spaceship.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/battle_hud.dart';

abstract class BattleScreen extends World
    with DragCallbacks, HasGameReference<MiningShooter>, KeyboardHandler {
  late final Spaceship _spaceship;

  SpawnComponent? _enemySpawner;

  @override
  Future<void> onLoad() async {
    await _initParallax();
    await _initSpaceShip();
    await _initHud();
    _initEnemySpawn();
  }

  @override
  void onDragStart(DragStartEvent event) async {
    super.onDragStart(event);

    if (!isRemoved) {
      _spaceship.startShooting();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    if (!isRemoved) {
      _spaceship.move(event.localDelta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);

    if (!isRemoved) {
      _spaceship.stopShooting();
    }
  }

  Future<void> _initHud() async {
    game.overlays.addEntry('Battle Hud', (context, game) {
      return BattleHud(game: game as MiningShooter, spaceship: _spaceship);
    });

    game.overlays.add('Battle Hud');
  }

  Future<void> _initSpaceShip() async {
    _spaceship = Spaceship()
      ..position = Vector2(4.5, 15)
      ..priority = 1
      ..anchor = Anchor.center;

    await add(_spaceship);
  }

  Future<void> _initParallax() async {
    final parallax = await game.loadParallaxComponent(
      [ParallaxImageData('stars_0.png')],

      repeat: ImageRepeat.repeat,

      baseVelocity: Vector2(0, -5),
    );

    await add(parallax);
  }

  Future<void> _initEnemySpawn();
}

class BattleArea1 extends BattleScreen {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  Future<void> _initEnemySpawn() async {
    final _bigAsteroidSpawner = SpawnComponent(
      area: Rectangle.fromLTWH(
        Asteroid.bigAsteroidSize / 2 / MiningShooter.pixelsPerUnit,
        0,
        game.size.x - Asteroid.bigAsteroidSize / MiningShooter.pixelsPerUnit,
        -Asteroid.asteroidSize + 8 / MiningShooter.pixelsPerUnit,
      ),
      factory: (index) {
        return BigDarkBlueAsteroid(health: 15, speed: 5.0);
      },
      period: 5,
    );

    await add(_bigAsteroidSpawner);

    for (int i = 1; i < 31; i++) {
      if (i > 1) {
        await Future.delayed(Duration(seconds: 5));
      }

      if (_enemySpawner != null) {
        _enemySpawner!.removeFromParent();
      }

      _enemySpawner = SpawnComponent(
        area: Rectangle.fromLTWH(
          Asteroid.asteroidSize / 2 / MiningShooter.pixelsPerUnit,
          0,
          game.size.x - Asteroid.asteroidSize / MiningShooter.pixelsPerUnit,
          -Asteroid.asteroidSize + 8 / MiningShooter.pixelsPerUnit,
        ),
        factory: (index) {
          return DarkBlueAsteroid(health: i, speed: 4.0);
        },
        period: 1,
      );

      await add(_enemySpawner!);

      if (i == 30) {
        break;
      }

      await Future.delayed(Duration(seconds: 30));
    }
  }
}

class BattleArea2 extends BattleScreen {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  Future<void> _initEnemySpawn() async {
    final _bigAsteroidSpawner = SpawnComponent(
      area: Rectangle.fromLTWH(
        Asteroid.bigAsteroidSize / 2 / MiningShooter.pixelsPerUnit,
        0,
        game.size.x - Asteroid.asteroidSize / MiningShooter.pixelsPerUnit,
        -Asteroid.asteroidSize + 8 / MiningShooter.pixelsPerUnit,
      ),
      factory: (index) {
        return BigBlueAsteroid(health: 45, speed: 6.0);
      },
      period: 5,
    );

    await add(_bigAsteroidSpawner);

    for (int i = 1; i < 31; i++) {
      if (i > 1) {
        await Future.delayed(Duration(seconds: 5));
      }

      if (_enemySpawner != null) {
        _enemySpawner!.removeFromParent();
      }

      _enemySpawner = SpawnComponent(
        area: Rectangle.fromLTWH(
          Asteroid.asteroidSize / 2 / MiningShooter.pixelsPerUnit,
          0,
          game.size.x - Asteroid.asteroidSize / MiningShooter.pixelsPerUnit,
          -Asteroid.asteroidSize + 8 / MiningShooter.pixelsPerUnit,
        ),
        factory: (index) {
          final effect = SequenceEffect(infinite: true, [
            MoveByEffect(
              Vector2(24 / MiningShooter.pixelsPerUnit, 0),
              LinearEffectController(1),
            ),
            MoveByEffect(
              Vector2(-24 / MiningShooter.pixelsPerUnit, 0),
              LinearEffectController(1),
            ),
          ]);

          return BlueAsteroid(health: i * 2, speed: 6.0)..add(effect);
        },
        period: 1,
      );

      await add(_enemySpawner!);

      if (i == 30) {
        break;
      }

      await Future.delayed(Duration(seconds: 30));
    }
  }
}

class BattleArea3 extends BattleScreen {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  Future<void> _initEnemySpawn() async {
    final _bigAsteroidSpawner = SpawnComponent(
      area: Rectangle.fromLTWH(
        Asteroid.bigAsteroidSize / 2 / MiningShooter.pixelsPerUnit,
        0,
        game.size.x - Asteroid.asteroidSize / MiningShooter.pixelsPerUnit,
        -Asteroid.asteroidSize + 8 / MiningShooter.pixelsPerUnit,
      ),
      factory: (index) {
        return BigRedAsteroid(health: 90, speed: 6.5);
      },
      period: 5,
    );

    await add(_bigAsteroidSpawner);

    for (int i = 1; i < 31; i++) {
      if (i > 1) {
        await Future.delayed(Duration(seconds: 5));
      }

      if (_enemySpawner != null) {
        _enemySpawner!.removeFromParent();
      }

      _enemySpawner = SpawnComponent(
        area: Rectangle.fromLTWH(
          Asteroid.asteroidSize / 2 / MiningShooter.pixelsPerUnit,
          0,
          game.size.x - Asteroid.asteroidSize / MiningShooter.pixelsPerUnit,
          -Asteroid.asteroidSize + 8 / MiningShooter.pixelsPerUnit,
        ),
        factory: (index) {
          final effect = MoveAlongPathEffect(
            Path()
              ..addOval(Rect.fromCircle(center: Offset(0, 0), radius: 0.25)),
            InfiniteEffectController(LinearEffectController(1)),
          );

          return RedAsteroid(health: i * 3, speed: 9.0)..add(effect);
        },
        period: 1,
      );

      await add(_enemySpawner!);

      if (i == 30) {
        break;
      }

      await Future.delayed(Duration(seconds: 30));
    }
  }
}
