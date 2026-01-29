import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/style/text.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class PurchaseDialog extends StatelessWidget {
  final Map<String, int> _costMap;

  final MiningShooter _game;

  final VoidCallback _onPurchase;

  PurchaseDialog({
    required Map<String, int> costMap,
    required MiningShooter game,
    required VoidCallback onPurchase,
  }) : _costMap = costMap,
       _game = game,
       _onPurchase = onPurchase {}

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
            image: AssetImage('assets/images/green-background.png'),
            width: 144,
            height: 96,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.none,
            centerSlice: Rect.fromLTWH(20, 20, 10, 10),
          ),
          Column(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpriteTextButton(
                onPressed: () {
                  _game.overlays.remove('Purchase Dialog');
                },
                text: 'Close',
                spriteName: 'button-blue',
                game: _game,
              ),
              Text('Do you want to purchase this ?', style: smallBlack),
              Text('Cost', style: smallBlack),
              _getCostLayout(),
              SpriteTextButton(
                onPressed: () {
                  _onPurchase();

                  _game.overlays.remove('Purchase Dialog');
                },
                text: 'Purchase',
                spriteName: 'button-blue',
                game: _game,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getCostLayout() {
    final columns = <Column>[];

    _costMap.entries.forEach((entry) {
      columns.add(
        Column(
          children: [
            SpriteWidget(
              sprite: _game.atlas.findSpriteByName(entry.key) as Sprite,
            ),
            Text(style: smallBlack, entry.value.toString()),
          ],
        ),
      );
    });

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: columns);
  }
}
