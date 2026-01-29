import 'package:flame/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mining_shooter/entity/spaceship.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class BattleHud extends StatelessWidget {
  final MiningShooter _game;

  final Spaceship _spaceship;

  BattleHud({required MiningShooter game, required Spaceship spaceship})
    : _game = game,
      _spaceship = spaceship;

  @override
  Widget build(BuildContext context) {
    return FitSizedBox(
      width: 144,
      height: 256,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthBar(
            healthListenable: _spaceship.currentHealth,
            game: _game,
            maxHealth: _spaceship.currentHealth.value,
          ),
          SpriteTextButton(
            onPressed: () => _game.overlays.add('Menu Dialog'),
            text: 'Menu',
            spriteName: 'button-blue',
            game: _game,
          ),
        ],
      ),
    );
  }
}

class HealthBar extends StatelessWidget {
  final ValueListenable<int> _healthListenable;

  final int _maxHealth;

  final MiningShooter _game;

  const HealthBar({
    super.key,
    required ValueListenable<int> healthListenable,
    required MiningShooter game,
    required int maxHealth,
  }) : _healthListenable = healthListenable,
       _maxHealth = maxHealth,
       _game = game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _healthListenable,
      builder: (context, health, _) {
        return Row(
          children: [
            for (int i = 0; i < _maxHealth; i++)
              if (health > i)
                SpriteWidget(
                  sprite: _game.atlas.findSpriteByName('health') as Sprite,
                )
              else
                SpriteWidget(
                  sprite:
                      _game.atlas.findSpriteByName('health-empty') as Sprite,
                ),
          ],
        );
      },
    );
  }
}
