import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mining_shooter/main.dart';
import 'package:mining_shooter/tiles/block.dart';
import 'package:mining_shooter/tiles/ore.dart';
import 'package:mining_shooter/tools/pickaxe.dart';

abstract class MiningScreen extends World with HasGameReference<MiningShooter> {
  late final Map<String, Map<String, double>> _oreChances;

  late final Pickaxe _pickaxe;

  late final _tileList = <Vector2>[];

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    await _initBackground();

    await _initRowOreChances();

    await _initPickaxe();

    await _initHud();

    await _initOres();
  }

  Future<void> _initOres() async {
    final random = Random();

    for (int y = 2; y < 14; y++) {
      for (int x = 0; x < 9; x++) {
        await add(
          getOre(
            y - 2,
            Vector2(x.toDouble().roundToDouble(), y.toDouble().roundToDouble()),
            random,
          ),
        );
      }
    }
  }

  Future<void> _initPickaxe() async {
    _pickaxe = Pickaxe();

    await add(_pickaxe);
  }

  Future<void> _initHud() async {
    await game.overlays.add('Mining Hud');
  }

  Future<void> _initBackground() async {
    await add(
      SpriteComponent(
        sprite: game.atlas.findSpriteByName('title-background'),
        size: Vector2(
          144 / MiningShooter.pixelsPerUnit,
          256 / MiningShooter.pixelsPerUnit,
        ),
      ),
    );
  }

  SpriteComponent getOre(int rowNumber, Vector2 position, Random random) {
    final roll = random.nextDouble();

    final chances = {
      'iron':
          (_oreChances['iron']!['base'] as double) +
          ((_oreChances['iron']!['addition'] as double) * rowNumber),
      'amethyst':
          (_oreChances['amethyst']!['base'] as double) +
          ((_oreChances['amethyst']!['addition'] as double) * rowNumber),
      'gold':
          (_oreChances['gold']!['base'] as double) +
          ((_oreChances['gold']!['addition'] as double) * rowNumber),
      'diamond':
          (_oreChances['diamond']!['base'] as double) +
          ((_oreChances['diamond']!['addition'] as double) * rowNumber),
    };

    double cumulative = 0.0;

    _tileList.add(position);

    for (final entry in chances.entries) {
      cumulative += entry.value;

      if (roll <= cumulative) {
        switch (entry.key) {
          case 'diamond':
            return DiamondOre(
              position: position,
              tileList: _tileList,
              pickaxe: _pickaxe,
            );
          case 'gold':
            return GoldOre(
              position: position,
              tileList: _tileList,
              pickaxe: _pickaxe,
            );
          case 'amethyst':
            return AmethystOre(
              position: position,
              tileList: _tileList,
              pickaxe: _pickaxe,
            );
          case 'iron':
            return IronOre(
              position: position,
              tileList: _tileList,
              pickaxe: _pickaxe,
            );
        }
      }
    }

    return Stone(position: position, pickaxe: _pickaxe, tileList: _tileList);
  }

  Future<void> _initRowOreChances();
}

class MiningArea1 extends MiningScreen {
  @override
  Future<void> _initRowOreChances() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/mining_area_1/ore_chances.json',
    );
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    _oreChances = decoded.map((key, value) {
      final oreMap = Map<String, double>.from(value);
      return MapEntry(key, oreMap);
    });
  }
}

class MiningArea2 extends MiningScreen {
  @override
  Future<void> _initRowOreChances() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/mining_area_2/ore_chances.json',
    );
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    _oreChances = decoded.map((key, value) {
      final oreMap = Map<String, double>.from(value);
      return MapEntry(key, oreMap);
    });
  }
}

class MiningArea3 extends MiningScreen {
  @override
  Future<void> _initRowOreChances() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/mining_area_3/ore_chances.json',
    );
    final Map<String, dynamic> decoded = jsonDecode(jsonString);

    _oreChances = decoded.map((key, value) {
      final oreMap = Map<String, double>.from(value);
      return MapEntry(key, oreMap);
    });
  }
}
