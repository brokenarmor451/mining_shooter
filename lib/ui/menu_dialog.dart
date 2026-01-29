import 'package:flutter/material.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class MenuDialog extends StatelessWidget {
  final MiningShooter _game;

  MenuDialog({required MiningShooter game}) : _game = game;

  @override
  Widget build(BuildContext context) {
    return FitSizedBox(
      width: 144,
      height: 256,
      child: Center(
        child: Stack(
          alignment: Alignment.center,

          children: [
            ModalBarrier(
              color: Colors.black.withValues(alpha: 0.5),
              dismissible: false,
            ),

            Image(
              width: 144,
              height: 95,
              image: AssetImage('assets/images/green-background.png'),
              centerSlice: Rect.fromLTWH(20, 20, 10, 10),
              filterQuality: FilterQuality.none,
              fit: BoxFit.fill,
            ),

            Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpriteTextButton(
                  onPressed: () => _game.overlays.remove('Menu Dialog'),
                  text: 'Close',
                  spriteName: 'button-blue',
                  game: _game,
                ),

                SpriteTextButton(
                  onPressed: () {
                    _game.overlays.add('Inventory');
                  },
                  text: 'Inventory',
                  spriteName: 'button-blue',
                  game: _game,
                ),

                SpriteTextButton(
                  onPressed: () {
                    _game.overlays.removeAll(_game.overlays.activeOverlays);
                    _game.world.removeFromParent();
                    _game.router.pushReplacementNamed('Main Menu');
                  },
                  text: 'Main Menu',
                  spriteName: 'button-blue',
                  game: _game,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
