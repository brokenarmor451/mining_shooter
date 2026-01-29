import 'package:flutter/material.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/style/text.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class InsufficientItemDialog extends StatelessWidget {
  final MiningShooter _game;

  InsufficientItemDialog({required MiningShooter game}) : _game = game;
  @override
  Widget build(BuildContext context) {
    return FitSizedBox(
      width: 144,
      height: 256,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.5),
            dismissible: false,
          ),
          Image(
            image: AssetImage('assets/images/red-background.png'),
            width: 144,
            height: 96,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.none,
            centerSlice: Rect.fromLTWH(20, 20, 10, 10),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You don\'t have enough items.', style: smallBlack),
              SpriteTextButton(
                onPressed: () =>
                    _game.overlays.remove('Insufficient Item Dialog'),
                text: 'Close',
                spriteName: 'button-blue',
                game: _game,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
