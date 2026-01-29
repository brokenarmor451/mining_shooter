import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:mining_shooter/entity/asteroid.dart';
import 'package:mining_shooter/entity/particle_effect.dart';
import 'package:mining_shooter/main.dart';

class Bullet extends SpriteComponent
    with HasGameReference<MiningShooter>, CollisionCallbacks {
  final int _damage;
  final _speed = 25;

  Bullet({required int damage, super.position})
    : _damage = damage,
      super(
        anchor: Anchor.center,
        size: Vector2(
          2 / MiningShooter.pixelsPerUnit,
          8 / MiningShooter.pixelsPerUnit,
        ),
      );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    _playLaserSound();

    sprite = game.atlas.findSpriteByName('bullet');

    await add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -_speed;

    if (position.y < -height) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Asteroid) {
      other.currentHealth -= _damage;
      other.add(
        ColorEffect(
          Color.fromARGB(100, 255, 0, 0),
          EffectController(duration: 0.1, reverseDuration: 0.1, repeatCount: 1),
        ),
      );

      removeFromParent();

      if (other.currentHealth <= 0) {
        game.world.add(
          AsteroidExplosion(position: other.position, color: other.color),
        );
        game.world.add(
          RewardParticleEffect(
            itemAmount: other.health,
            itemName: 'coin',
            position: game.size - Vector2.all(16 / MiningShooter.pixelsPerUnit),
          ),
        );
        game.saveManager.inventory.addItem('coin', 'coin', other.health);
        _playCoinCollectSound();
        other.removeFromParent();
      }
    }
  }

  void _playLaserSound() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }

    if (game.saveManager.settings.soundOn) {
      game.audioManager.laserSoundHandle = await game.audioManager.soloud.play(
        game.audioManager.laserSoundSource,
      );
    }
  }

  void _playCoinCollectSound() async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return;
    }

    if (game.saveManager.settings.soundOn) {
      game.audioManager.itemCollectSoundHandle = await game.audioManager.soloud
          .play(game.audioManager.itemCollectSoundSource);
    }
  }
}
