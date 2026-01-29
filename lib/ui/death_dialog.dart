import 'package:flutter/material.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/style/text.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class DeathDialog extends StatelessWidget {
  final MiningShooter _game;

  DeathDialog({required MiningShooter game}) : _game = game {}

  @override
  Widget build(BuildContext context) {
    return FitLayout(
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
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You died.', style: smallBlack),

              SpriteTextButton(
                onPressed: () {
                  _game.overlays.removeAll(_game.overlays.activeOverlays);

                  _game.router.pushReplacementNamed('Main Menu');
                },
                game: _game,
                text: 'Main Menu',
                spriteName: 'button-blue',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
