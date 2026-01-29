import 'dart:convert';

import 'package:flame/widgets.dart';
import 'package:flutter/cupertino.dart' hide OverlayRoute;
import 'package:flutter/services.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';
import 'package:mining_shooter/ui/purchase_dialog.dart';

class BattleSelectScreen extends StatefulWidget {
  final MiningShooter _game;

  BattleSelectScreen({required MiningShooter game}) : _game = game {}

  @override
  State<StatefulWidget> createState() => _BattleSelectScreenState();
}

class _BattleSelectScreenState extends State<BattleSelectScreen> {
  Map<String, dynamic>? _areaCostMap;

  Future<Map<String, dynamic>> _loadAreaCostData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/area_cost/area_costs.json',
    );

    final data = jsonDecode(jsonString);

    return data;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await _loadAreaCostData();
      setState(() {
        _areaCostMap = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FitSizedBox(
      width: 144,
      height: 256,
      child: Stack(
        alignment: Alignment.center,

        children: [
          SpriteWidget(
            sprite:
                widget._game.atlas.findSpriteByName('title-background')
                    as Sprite,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              SpriteTextButton(
                onPressed: () =>
                    widget._game.router.pushReplacementNamed('Main Menu'),
                text: 'Close',
                spriteName: 'button-blue',
                game: widget._game,
              ),

              SpriteTextButton(
                onPressed: () =>
                    widget._game.router.pushReplacementNamed('Battle Area 1'),
                text: 'Battle Area 1',
                spriteName: 'button-blue',
                game: widget._game,
              ),

              SpriteTextButton(
                onPressed: () => _enterArea('Battle Area 2'),
                text: 'Battle Area 2',
                spriteName: _getButtonStyle('Battle Area 2'),
                game: widget._game,
              ),

              SpriteTextButton(
                onPressed: () => _enterArea('Battle Area 3'),
                text: 'Battle Area 3',
                spriteName: _getButtonStyle('Battle Area 3'),
                game: widget._game,
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getAreaCost(String name, String oreName) {
    return _areaCostMap![name][oreName] as int;
  }

  void _purchaseArea(String name) {
    final inventory = widget._game.saveManager.inventory;

    final ironOreCount = inventory.itemMap['iron-ore']?.count ?? 0;
    final goldOreCount = inventory.itemMap['gold-ore']?.count ?? 0;
    final amethystOreCount = inventory.itemMap['amethyst-ore']?.count ?? 0;
    final diamondOreCount = inventory.itemMap['diamond-ore']?.count ?? 0;

    final ironOreCost = _getAreaCost(name, 'iron-ore');
    final amethystOreCost = _getAreaCost(name, 'amethyst-ore');
    final goldOreCost = _getAreaCost(name, 'iron-ore');
    final diamondOreCost = _getAreaCost(name, 'diamond-ore');

    if (ironOreCount < ironOreCost ||
        goldOreCount < goldOreCost ||
        amethystOreCount < amethystOreCost ||
        diamondOreCount < diamondOreCost) {
      widget._game.overlays.add('Insufficient Item Dialog');
      return;
    }

    inventory.removeItem('iron-ore', ironOreCost);
    inventory.removeItem('gold-ore', goldOreCost);
    inventory.removeItem('amethyst-ore', amethystOreCost);
    inventory.removeItem('diamond-ore', diamondOreCost);

    setState(() {
      widget._game.saveManager.areaPurchaseData.purchaseMap[name] = true;
    });
  }

  void _enterArea(String name) {
    if (!widget._game.saveManager.areaPurchaseData.purchaseMap[name]!) {
      widget._game.overlays.addEntry('Purchase Dialog', (context, game) {
        return PurchaseDialog(
          onPurchase: () => _purchaseArea(name),
          costMap: {
            'iron-ore': _getAreaCost(name, 'iron-ore'),
            'amethyst-ore': _getAreaCost(name, 'amethyst-ore'),
            'gold-ore': _getAreaCost(name, 'gold-ore'),
            'diamond-ore': _getAreaCost(name, 'diamond-ore'),
          },
          game: widget._game,
        );
      });

      widget._game.overlays.add('Purchase Dialog');

      return;
    }

    widget._game.router.pushReplacementNamed(name);
  }

  String _getButtonStyle(String name) {
    if (!widget._game.saveManager.areaPurchaseData.purchaseMap[name]!) {
      return 'button-gray';
    }

    return 'button-blue';
  }
}
