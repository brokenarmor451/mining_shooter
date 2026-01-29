import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/style/text.dart';

class DigParticleEffect extends SpriteAnimationComponent
    with HasGameReference<MiningShooter> {
  DigParticleEffect({super.position})
    : super(
        size: Vector2.all(16 / MiningShooter.pixelsPerUnit),
        anchor: Anchor.center,
      );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    animation = SpriteAnimation.spriteList(
      game.atlas.findSpritesByName('dig-particle'),
      stepTime: 0.1,
      loop: false,
    );

    removeOnFinish = true;
  }
}

class RewardParticleEffect extends SpriteAnimationComponent
    with HasGameReference<MiningShooter> {
  final int _itemAmount;

  final String _itemName;

  RewardParticleEffect({
    required int itemAmount,
    required String itemName,
    super.position,
  }) : _itemAmount = itemAmount,
       _itemName = itemName,
       super(
         size: Vector2.all(16 / MiningShooter.pixelsPerUnit),
         anchor: Anchor.center,
       );

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    animation = SpriteAnimation.spriteList(
      game.atlas.findSpritesByName('coin-particle'),
      stepTime: 0.1,
      loop: false,
    );

    removeOnFinish = true;

    final coinText = TextComponent(
      text: '+ ' + _itemAmount.toString(),
      textRenderer: TextPaint(style: smallGreen),
      position: Vector2(8 / MiningShooter.pixelsPerUnit, 0),
    );

    final coinSprite = SpriteComponent(
      sprite: game.atlas.findSpriteByName(_itemName),
      size: Vector2.all(16 / MiningShooter.pixelsPerUnit),
      scale: Vector2.all(0.5),
      anchor: Anchor.center,
    )..position.add(Vector2.all(8 / MiningShooter.pixelsPerUnit));

    coinText.add(
      MoveByEffect(
        Vector2(0, -8 / MiningShooter.pixelsPerUnit),
        LinearEffectController(0.5),
      ),
    );

    add(coinSprite);

    add(coinText);
  }
}

class AsteroidExplosion extends SpriteAnimationComponent
    with HasGameReference<MiningShooter> {
  final String _color;

  AsteroidExplosion({required String color, super.position})
    : _color = color,
      super(
        anchor: Anchor.center,
        removeOnFinish: true,
        size: Vector2.all(16 / MiningShooter.pixelsPerUnit),
      );

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    animation = SpriteAnimation.spriteList(
      loop: false,
      game.atlas.findSpritesByName('asteroid-explosion-' + _color),
      stepTime: 0.2,
    );
  }
}
