import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:mining_shooter/data/spaceship_data.dart';
import 'package:mining_shooter/entity/bullet.dart';
import 'package:mining_shooter/main.dart';

class Spaceship extends SpriteAnimationComponent
    with HasGameReference<MiningShooter>, CollisionCallbacks {
  late final SpaceshipData _data;

  late final SpawnComponent _bulletSpawner;

  late ValueNotifier<int> _currentHealth;
  ValueNotifier<int> get currentHealth => _currentHealth;
  void set currentHealth(ValueNotifier<int> currentHealth) =>
      _currentHealth = currentHealth;

  static const spaceshipSize = 16.0;

  Spaceship()
    : super(
        size: Vector2.all(spaceshipSize / MiningShooter.pixelsPerUnit),
        anchor: Anchor.center,
      ) {}
  @override
  FutureOr<void> onLoad() {
    _initAnimation();

    _initData();

    _initBulletSpawner();

    _initCurrentHealth();

    add(RectangleHitbox());
  }

  void move(Vector2 delta) {
    position.add(delta);

    if (position.x < width / 2) {
      position.x = width / 2;
    }

    if (position.x > game.size.x - width / 2) {
      position.x = game.size.x - width / 2;
    }

    if (position.y < height / 2) {
      position.y = height / 2;
    }

    if (position.y > game.size.y - height / 2) {
      position.y = game.size.y - height / 2;
    }
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  void _initData() {
    _data = game.saveManager.spaceship;
  }

  void _initAnimation() {
    animation = SpriteAnimation.spriteList(
      game.atlas.findSpritesByName('spaceship'),
      stepTime: 0.2,
    );
  }

  void _initBulletSpawner() {


    _bulletSpawner = SpawnComponent(
      period: 0.15,
      selfPositioning: true,
      autoStart: false,
      multiFactory: (amount) {

            final bulletSpawnPositions = <Vector2>[];

    switch (_data.bullet) {
      case 1:
        bulletSpawnPositions.add(position + Vector2(0, -height / 2));

        break;

      case 2:
        bulletSpawnPositions.add(
          position + Vector2(2 / MiningShooter.pixelsPerUnit, -height / 2),
        );
        bulletSpawnPositions.add(
          position + Vector2(-2 / MiningShooter.pixelsPerUnit, -height / 2),
        );
        break;

      case 3:
        bulletSpawnPositions.add(position + Vector2(0, -height / 2));

        bulletSpawnPositions.add(
          position + Vector2(4 / MiningShooter.pixelsPerUnit, -height / 2),
        );
        bulletSpawnPositions.add(
          position + Vector2(-4 / MiningShooter.pixelsPerUnit, -height / 2),
        );

        break;
    }

        final bullets = <Bullet>[];



        for (final bulletSpawnPosition in bulletSpawnPositions) {
          bullets.add(
            Bullet(damage: _data.attack, position: bulletSpawnPosition),
          );
        }

        return bullets;
      },
    );

    game.world.add(_bulletSpawner);
  }

  void _initCurrentHealth() {
    _currentHealth = ValueNotifier(_data.health);
  }
}
