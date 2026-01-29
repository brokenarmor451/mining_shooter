import 'dart:convert';

import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide OverlayRoute;
import 'package:flutter/services.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';
import 'package:mining_shooter/ui/purchase_dialog.dart';

class MiningSelectScreen extends StatefulWidget {
  final MiningShooter _game;

  MiningSelectScreen({required MiningShooter game}) : _game = game {}

  @override
  State<StatefulWidget> createState() => _MiningSelectScreenState();
}

class _MiningSelectScreenState extends State<MiningSelectScreen> {
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
    if (_areaCostMap == null) {
      return LinearProgressIndicator();
    }

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
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    widget._game.router.pushReplacementNamed('Mining Area 1'),
                text: 'Mining Area 1',
                spriteName: 'button-blue',
                game: widget._game,
              ),

              SpriteTextButton(
                onPressed: () => _enterArea('Mining Area 2'),
                text: 'Mining Area 2',
                spriteName: _getButtonStyle('Mining Area 2'),
                game: widget._game,
              ),

              SpriteTextButton(
                onPressed: () => _enterArea('Mining Area 3'),
                text: 'Mining Area 3',
                spriteName: _getButtonStyle('Mining Area 3'),
                game: widget._game,
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getAreaCost(String name) {
    return _areaCostMap![name]['coins'] as int;
  }

  void _purchaseArea(String name) {
    final inventory = widget._game.saveManager.inventory;

    final coinCount = inventory.itemMap['coin']?.count ?? 0;

    final coinCost = _getAreaCost(name);

    if (coinCount < coinCost) {
      widget._game.overlays.add('Insufficient Item Dialog');

      return;
    }

    setState(() {
      inventory.removeItem('coin', coinCost);
      widget._game.saveManager.areaPurchaseData.purchaseMap[name] = true;
    });
  }

  void _enterArea(String name) {
    if (!widget._game.saveManager.areaPurchaseData.purchaseMap[name]!) {
      widget._game.overlays.addEntry('Purchase Dialog', (context, game) {
        return PurchaseDialog(
          onPurchase: () => _purchaseArea(name),
          costMap: {'coin': _getAreaCost(name)},
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
