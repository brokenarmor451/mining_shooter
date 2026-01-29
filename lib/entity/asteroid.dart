import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:mining_shooter/entity/particle_effect.dart';
import 'package:mining_shooter/entity/spaceship.dart';
import 'package:mining_shooter/main.dart';

abstract class Asteroid extends SpriteComponent
    with HasGameReference<MiningShooter>, CollisionCallbacks {
  final double _speed;

  final int _health;
  int get health => _health;

  final String _color;
  String get color => _color;

  int _currentHealth;
  int get currentHealth => _currentHealth;
  void set currentHealth(int currentHealth) => _currentHealth = currentHealth;

  static const asteroidSize = 16.0;

  static const bigAsteroidSize = 32.0;

  Asteroid({
    required int health,
    required double speed,
    required String color,
    super.anchor,
    super.size,
  }) : _color = color,
       _health = health,
       _currentHealth = health,
       _speed = speed;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    await _initSprite();

    await add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += _speed * dt;

    if (position.y > game.size.y + height / 2) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Spaceship) {
      other.currentHealth.value--;
      other.add(
        ColorEffect(
          Color.fromARGB(100, 255, 0, 0),
          EffectController(duration: 0.1, reverseDuration: 0.1, repeatCount: 1),
        ),
      );
      game.world.add(AsteroidExplosion(position: position, color: _color));
      removeFromParent();

      if (other.currentHealth.value <= 0) {
        game.world.removeFromParent();
        game.overlays.remove('Battle Hud');
        game.overlays.add('Death Dialog');
      }
    }
  }

  Future<void> _initSprite();
}

class DarkBlueAsteroid extends Asteroid {
  DarkBlueAsteroid({required super.health, required super.speed})
    : super(
        size: Vector2.all(Asteroid.asteroidSize / MiningShooter.pixelsPerUnit),
        anchor: Anchor.center,
        color: 'dark-blue',
      );

  @override
  Future<void> _initSprite() async {
    sprite = game.atlas.findSpriteByName('asteroid-dark-blue');
  }
}

class BlueAsteroid extends Asteroid {
  BlueAsteroid({required super.health, required super.speed})
    : super(
        size: Vector2.all(Asteroid.asteroidSize / MiningShooter.pixelsPerUnit),
        anchor: Anchor.center,
        color: 'blue',
      );

  @override
  Future<void> _initSprite() async {
    sprite = game.atlas.findSpriteByName('asteroid-blue');
  }
}

class RedAsteroid extends Asteroid {
  RedAsteroid({required super.health, required super.speed})
    : super(
        size: Vector2.all(Asteroid.asteroidSize / MiningShooter.pixelsPerUnit),
        anchor: Anchor.center,
        color: 'red',
      );

  @override
  Future<void> _initSprite() async {
    sprite = game.atlas.findSpriteByName('asteroid-red');
  }
}

class BigDarkBlueAsteroid extends Asteroid {
  BigDarkBlueAsteroid({required super.health, required super.speed})
    : super(
        anchor: Anchor.center,
        size: Vector2.all(
          Asteroid.bigAsteroidSize / MiningShooter.pixelsPerUnit,
        ),
        color: 'dark-blue',
      );

  @override
  Future<void> _initSprite() async {
    sprite = game.atlas.findSpriteByName('asteroid-big-dark-blue');
  }
}

class BigBlueAsteroid extends Asteroid {
  BigBlueAsteroid({required super.health, required super.speed})
    : super(
        anchor: Anchor.center,
        size: Vector2.all(
          Asteroid.bigAsteroidSize / MiningShooter.pixelsPerUnit,
        ),
        color: 'blue',
      );

  @override
  Future<void> _initSprite() async {
    sprite = game.atlas.findSpriteByName('asteroid-big-blue');
  }
}

class BigRedAsteroid extends Asteroid {
  BigRedAsteroid({required super.health, required super.speed})
    : super(
        anchor: Anchor.center,
        size: Vector2.all(
          Asteroid.bigAsteroidSize / MiningShooter.pixelsPerUnit,
        ),
        color: 'red',
      );

  @override
  Future<void> _initSprite() async {
    sprite = game.atlas.findSpriteByName('asteroid-big-red');
  }
}
