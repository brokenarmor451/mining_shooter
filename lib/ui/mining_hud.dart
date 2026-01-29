import 'package:flutter/material.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class MiningHud extends StatelessWidget {
  final MiningShooter _game;

  MiningHud({required MiningShooter game}) : _game = game;

  @override
  Widget build(BuildContext context) {
    return FitSizedBox(
      width: 144,
      height: 256,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
