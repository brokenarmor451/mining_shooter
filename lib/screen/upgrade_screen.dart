import 'dart:convert';

import 'package:flame/widgets.dart';
import 'package:flutter/material.dart' hide OverlayRoute;
import 'package:flutter/services.dart';
import 'package:mining_shooter/inventory/inventory.dart';
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/style/text.dart';
import 'package:mining_shooter/ui/button.dart';
import 'package:mining_shooter/ui/fit_layout.dart';

class UpgradeScreen extends StatefulWidget {
  final MiningShooter _game;

  UpgradeScreen({required MiningShooter game}) : _game = game;

  @override
  State<StatefulWidget> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  Map<String, dynamic>? _upgradeData;

  final oreNames = ['iron-ore', 'gold-ore', 'amethyst-ore', 'diamond-ore'];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await _loadUpgradeData();
      setState(() {
        _upgradeData = data;
      });
    });
  }

  Future<Map<String, dynamic>> _loadUpgradeData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/upgrade/upgrades.json',
    );

    final data = jsonDecode(jsonString);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (_upgradeData == null) {
      return LinearProgressIndicator();
    }

    return FitSizedBox(
      width: 144,
      height: 256,
      child: Stack(
        children: [
          SpriteWidget(
            sprite:
                widget._game.atlas.findSpriteByName('title-background')
                    as Sprite,
          ),

          Column(
            spacing: 8,
            children: [
              Column(
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
                    onPressed: () => widget._game.overlays.add('Inventory'),
                    text: 'Inventory',
                    spriteName: 'button-blue',
                    game: widget._game,
                  ),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            width: 144,
                            height: 95,
                            image: AssetImage(
                              'assets/images/brown-background.png',
                            ),
                            centerSlice: Rect.fromLTWH(20, 20, 10, 10),
                            filterQuality: FilterQuality.none,
                            fit: BoxFit.fill,
                          ),
                          _getHealthLayout(),
                        ],
                      ),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            width: 144,
                            height: 95,
                            image: AssetImage(
                              'assets/images/brown-background.png',
                            ),
                            centerSlice: Rect.fromLTWH(20, 20, 10, 10),
                            filterQuality: FilterQuality.none,
                            fit: BoxFit.fill,
                          ),
                          _getAttackLayout(),
                        ],
                      ),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            width: 144,
                            height: 95,
                            image: AssetImage(
                              'assets/images/brown-background.png',
                            ),
                            centerSlice: Rect.fromLTWH(20, 20, 10, 10),
                            filterQuality: FilterQuality.none,
                            fit: BoxFit.fill,
                          ),
                          _getBulletLayout(),
                        ],
                      ),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            width: 144,
                            height: 95,
                            image: AssetImage(
                              'assets/images/brown-background.png',
                            ),
                            centerSlice: Rect.fromLTWH(20, 20, 10, 10),
                            filterQuality: FilterQuality.none,
                            fit: BoxFit.fill,
                          ),
                          _getPickaxeLayout(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getHealthCost(String oreName) {
    final Map<String, dynamic> healthUpgradeData =
        _upgradeData!['health_upgrade'];

    final int healthLevel = widget._game.saveManager.spaceship.healthLevel;

    final int oreCost = healthUpgradeData['ores'][oreName] as int;

    final int costMultiplier = healthUpgradeData['cost_multiplier'];

    return oreCost + (healthLevel * costMultiplier);
  }

  int _getAttackCost(String oreName) {
    final Map<String, dynamic> attackUpgradeData =
        _upgradeData!['attack_upgrade'];

    final int attackLevel = widget._game.saveManager.spaceship.attackLevel;

    final int oreCost = attackUpgradeData['ores'][oreName] as int;

    final int costMultiplier = attackUpgradeData['cost_multiplier'];

    return oreCost + (attackLevel * costMultiplier);
  }

  int _getBulletCost(String oreName) {
    final Map<String, dynamic> attackUpgradeData =
        _upgradeData!['bullet_upgrade'];

    final int attackLevel = widget._game.saveManager.spaceship.attackLevel;

    final int oreCost = attackUpgradeData['ores'][oreName] as int;

    final int costMultiplier = attackUpgradeData['cost_multiplier'];

    return oreCost + (attackLevel * costMultiplier);
  }

  int _getPickaxeDamageCost() {
    final Map<String, dynamic> pickaxeUpgradeData =
        _upgradeData!['pickaxe_upgrade'];

    final int pickaxeLevel = widget._game.saveManager.pickaxe.level;

    final int coinCost = pickaxeUpgradeData['coins'] as int;

    final int costMultipler = pickaxeUpgradeData['cost_multiplier'];

    return coinCost + pickaxeLevel * costMultipler;
  }

  Widget _getHealthLayout() {
    return Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text('Health', style: smallBlack),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 1.0,
              children: [
                for (
                  int i = 0;
                  i < widget._game.saveManager.spaceship.health;
                  i++
                )
                  SpriteWidget(
                    sprite:
                        widget._game.atlas.findSpriteByName('health') as Sprite,
                  ),
              ],
            ),
          ],
        ),

        if (!_spaceShipHealthMaxLevel())
          Column(
            children: [
              Text('Cost', style: smallBlack),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (String oreName in oreNames)
                    Column(
                      children: [
                        SpriteWidget(
                          sprite:
                              widget._game.atlas.findSpriteByName(oreName)
                                  as Sprite,
                        ),

                        Text(
                          _getHealthCost(oreName).toString(),
                          style: smallBlack,
                        ),
                      ],
                    ),
                ],
              ),

              if (!(_spaceShipHealthMaxLevel()))
                SpriteTextButton(
                  onPressed: _upgradeHealth,
                  text: 'Upgrade',
                  spriteName: 'button-blue',
                  game: widget._game,
                ),
            ],
          ),
      ],
    );
  }

  Widget _getAttackLayout() {
    return Row(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SpriteWidget(
              sprite:
                  widget._game.atlas.findSpriteByName('spaceship') as Sprite,
            ),

            Text('Attack', style: smallBlack),

            Text(
              '${widget._game.saveManager.spaceship.attack}',
              style: smallBlack,
            ),
          ],
        ),

        if (!_spaceShipAttackMaxLevel())
          Column(
            children: [
              Text('Cost', style: smallBlack),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (String oreName in oreNames)
                    Column(
                      children: [
                        SpriteWidget(
                          sprite:
                              widget._game.atlas.findSpriteByName(oreName)
                                  as Sprite,
                        ),

                        Text(
                          _getAttackCost(oreName).toString(),
                          style: smallBlack,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),

        if (!_spaceShipAttackMaxLevel())
          SpriteTextButton(
            onPressed: _upgradeAttack,
            text: 'Upgrade',
            spriteName: 'button-blue',
            game: widget._game,
          ),
      ],
    );
  }

  Widget _getBulletLayout() {
    return Row(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SpriteWidget(
              sprite:
                  widget._game.atlas.findSpriteByName('spaceship') as Sprite,
            ),

            Text('Bullet', style: smallBlack),

            Text(
              '${widget._game.saveManager.spaceship.bullet}',
              style: smallBlack,
            ),
          ],
        ),

        if (!_spaceShipBulletMaxLevel())
          Column(
            children: [
              Text('Cost', style: smallBlack),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (String oreName in oreNames)
                    Column(
                      children: [
                        SpriteWidget(
                          sprite:
                              widget._game.atlas.findSpriteByName(oreName)
                                  as Sprite,
                        ),

                        Text(
                          _getBulletCost(oreName).toString(),
                          style: smallBlack,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),

        if (!_spaceShipBulletMaxLevel())
          SpriteTextButton(
            onPressed: _upgradeBullet,
            text: 'Upgrade',
            spriteName: 'button-blue',
            game: widget._game,
          ),
      ],
    );
  }

  Widget _getPickaxeLayout() {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SpriteWidget(
              sprite: widget._game.atlas.findSpriteByName('pickaxe') as Sprite,
            ),

            Text('Damage', style: smallBlack),

            Text(
              '${widget._game.saveManager.pickaxe.damage}',
              style: smallBlack,
            ),
          ],
        ),

        if (!_pickaxeDamageMaxLevel())
          Column(
            children: [
              Column(
                children: [
                  Text('Cost', style: smallBlack),
                  SpriteWidget(
                    sprite:
                        widget._game.atlas.findSpriteByName('coin') as Sprite,
                  ),

                  Text(_getPickaxeDamageCost().toString(), style: smallBlack),
                ],
              ),
            ],
          ),

        if (!_pickaxeDamageMaxLevel())
          SpriteTextButton(
            onPressed: _upgradePickaxeDamage,
            text: 'Upgrade',
            spriteName: 'button-blue',
            game: widget._game,
          ),
      ],
    );
  }

  void _upgradeHealth() {
    final Inventory inventory = widget._game.saveManager.inventory;

    final ironOreCount = inventory.itemMap['iron-ore']?.count ?? 0;
    final goldOreCount = inventory.itemMap['gold-ore']?.count ?? 0;
    final amethystOreCount = inventory.itemMap['amethyst-ore']?.count ?? 0;
    final diamondOreCount = inventory.itemMap['diamond-ore']?.count ?? 0;

    final ironOreCost = _getHealthCost('iron-ore');
    final goldOreCost = _getHealthCost('gold-ore');
    final amethystOreCost = _getHealthCost('amethyst-ore');
    final diamondOreCost = _getHealthCost('diamond-ore');

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
      widget._game.saveManager.spaceship.healthLevel++;
      widget._game.saveManager.spaceship.health++;
    });
  }

  void _upgradeAttack() {
    final Inventory inventory = widget._game.saveManager.inventory;

    final ironOreCount = inventory.itemMap['iron-ore']?.count ?? 0;
    final goldOreCount = inventory.itemMap['gold-ore']?.count ?? 0;
    final amethystOreCount = inventory.itemMap['amethyst-ore']?.count ?? 0;
    final diamondOreCount = inventory.itemMap['diamond-ore']?.count ?? 0;

    final ironOreCost = _getAttackCost('iron-ore');
    final goldOreCost = _getAttackCost('gold-ore');
    final amethystOreCost = _getAttackCost('amethyst-ore');
    final diamondOreCost = _getAttackCost('diamond-ore');

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
      widget._game.saveManager.spaceship.attackLevel++;
      widget._game.saveManager.spaceship.attack++;
    });
  }

  void _upgradeBullet() {
    final Inventory inventory = widget._game.saveManager.inventory;

    final ironOreCount = inventory.itemMap['iron-ore']?.count ?? 0;
    final goldOreCount = inventory.itemMap['gold-ore']?.count ?? 0;
    final amethystOreCount = inventory.itemMap['amethyst-ore']?.count ?? 0;
    final diamondOreCount = inventory.itemMap['diamond-ore']?.count ?? 0;

    final ironOreCost = _getBulletCost('iron-ore');
    final goldOreCost = _getBulletCost('gold-ore');
    final amethystOreCost = _getBulletCost('amethyst-ore');
    final diamondOreCost = _getBulletCost('diamond-ore');

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
      widget._game.saveManager.spaceship.bulletLevel++;
      widget._game.saveManager.spaceship.bullet++;
    });
  }

  void _upgradePickaxeDamage() {
    final inventory = widget._game.saveManager.inventory;

    final coinCount = inventory.itemMap['coin']?.count ?? 0;

    final damageMultiplier =
        _upgradeData!['pickaxe_upgrade']['damage_multiplier'] as int;

    final coinCost = _getPickaxeDamageCost();

    if (coinCount < coinCost) {
      widget._game.overlays.add('Insufficient Item Dialog');
      return;
    }

    inventory.removeItem('coin', coinCost);

    setState(() {
      widget._game.saveManager.pickaxe.level++;
      widget._game.saveManager.pickaxe.damage += damageMultiplier;
    });
  }

  bool _pickaxeDamageMaxLevel() {
    return widget._game.saveManager.pickaxe.level ==
        _upgradeData!['pickaxe_upgrade']['max_level'];
  }

  bool _spaceShipAttackMaxLevel() {
    return widget._game.saveManager.spaceship.attackLevel ==
        _upgradeData!['attack_upgrade']['max_level'];
  }

  bool _spaceShipBulletMaxLevel() {
    return widget._game.saveManager.spaceship.bulletLevel ==
        _upgradeData!['bullet_upgrade']['max_level'];
  }

  bool _spaceShipHealthMaxLevel() {
    return widget._game.saveManager.spaceship.healthLevel ==
        _upgradeData!['health_upgrade']['max_level'];
  }
}
