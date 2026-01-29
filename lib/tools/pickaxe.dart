import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:mining_shooter/data/pickaxe_data.dart';
import 'package:mining_shooter/entity/particle_effect.dart';
import 'package:mining_shooter/main.dart';

class Pickaxe extends SpriteComponent
    with HasGameReference<MiningShooter> {

  late final PickaxeData _data;
  PickaxeData get data => _data;

  late final SpawnComponent _digParticleEffectSpawner;
  double digParticleElapsedTime = 0;

  SpriteComponent? _currentTile;

  SpriteComponent? get currentTile => _currentTile;

  Pickaxe()
    : super(
        size: Vector2.all(8 / MiningShooter.pixelsPerUnit),
        position: Vector2(4.5,1),
        anchor: Anchor.center,
        priority: 1,
      );

  @override
  FutureOr<void> onLoad() {
    sprite = game.atlas.findSpriteByName('pickaxe');

    _data = game.saveManager.pickaxe;

    _digParticleEffectSpawner = SpawnComponent(
      selfPositioning: true,
      factory: (index) {
        return DigParticleEffect(position: position);
      },
      autoStart: false,
      period: 0.25
    );

    game.world.add(_digParticleEffectSpawner);

  }

  void startDigParticleEffect(double dt) {
    digParticleElapsedTime += dt;
    if(digParticleElapsedTime >= 0.5) {

      game.world.add(DigParticleEffect(position: position));

      digParticleElapsedTime = 0.0;

    }
  }

  void start(Vector2 position, SpriteComponent currentTile) {

    this.position = position;

    this._currentTile = currentTile;

    game.world.add(DigParticleEffect(position:  position));

    add(
        SequenceEffect(
          infinite: true,
          [
          RotateEffect.by(pi / 4, LinearEffectController(0.1)),
          RotateEffect.by(-pi / 4, LinearEffectController(0.1)),
        ]),
      );

    _digParticleEffectSpawner.timer.start();

  }

  void stop() {
    _digParticleEffectSpawner.timer.stop();

      angle = 0.0;    

    removeWhere(
      (Component component)  {
        return component is SequenceEffect;
      } );
  }
}
