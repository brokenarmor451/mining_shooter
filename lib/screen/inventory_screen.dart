import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:mining_shooter/inventory/item.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/style/text.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class InventoryScreen extends StatelessWidget {
  final MiningShooter _game;

  InventoryScreen({required MiningShooter game}) : _game = game {}

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
          Column(
            children: [
              SpriteTextButton(
                onPressed: () {
                  _game.overlays.remove('Inventory');
                },
                game: _game,
                text: 'Close',
                spriteName: 'button-blue',
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 128,
                    child: SpriteWidget(
                      anchor: Anchor.center,
                      sprite:
                          _game.atlas.findSpriteByName('inventory-background')
                              as Sprite,
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    height: 110,
                    child: ListView(children: _buildSlots()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Row> _buildSlots() {
    final rows = <Row>[];

    final items = _game.saveManager.inventory.itemMap.values.iterator;

    for (int i = 0; i < 8; i++) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [for (int i = 0; i < 4; i++) _generateSlot(items)],
        ),
      );
    }

    return rows;
  }

  Widget _generateSlot(Iterator<Item> items) {
    if (items.moveNext()) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(2),
            child: SpriteWidget(
              sprite: _game.atlas.findSpriteByName('slot') as Sprite,
            ),
          ),
          Column(
            children: [
              SpriteWidget(
                sprite:
                    _game.atlas.findSpriteByName(items.current.id) as Sprite,
              ),
              Text(formatNumber(items.current.count), style: smallLightGreen),
            ],
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.all(2),
      child: SpriteWidget(
        sprite: _game.atlas.findSpriteByName('slot') as Sprite,
      ),
    );
  }
}

String formatNumber(num number) {
  if (number >= 1000000000) {
    return "${(number / 1000000000).toStringAsFixed(number % 1000000000 == 0 ? 0 : 2)}B";
  } else if (number >= 1000000) {
    return "${(number / 1000000).toStringAsFixed(number % 1000000 == 0 ? 0 : 2)}M";
  } else if (number >= 1000) {
    return "${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 2)}K";
  } else {
    return number.toString();
  }
}
