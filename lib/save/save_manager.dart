import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mining_shooter/data/area_purchase_data.dart';
import 'package:mining_shooter/data/pickaxe_data.dart';
import 'package:mining_shooter/data/settings_data.dart';
import 'package:mining_shooter/data/spaceship_data.dart';
import 'package:mining_shooter/inventory/inventory.dart';
import 'package:path_provider/path_provider.dart';

class SaveManager {
  late final Inventory _inventory;
  Inventory get inventory => _inventory;

  late final SettingsData _settings;
  SettingsData get settings => _settings;

  late final SpaceshipData _spaceship;
  SpaceshipData get spaceship => _spaceship;

  late final PickaxeData _pickaxe;
  PickaxeData get pickaxe => _pickaxe;

  late final AreaPurchaseData _areaPurchaseData;
  AreaPurchaseData get areaPurchaseData => _areaPurchaseData;

  late final File _inventoryFile;

  late final File _spaceshipFile;

  late final File _pickaxeFile;

  late final File _areaPurchaseFile;

  late final File _settingsFile;

  SaveManager();

  Future<String> get _localPath async {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      final dir = Directory.systemTemp.createTempSync('save_manager_test');
      return dir.path;
    }

    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  Future<void> load() async {
    try {
      final localPath = await _localPath;

      _inventoryFile = File('$localPath/inventory.json');

      _spaceshipFile = File('$localPath/spaceship.json');

      _pickaxeFile = File('$localPath/pickaxe.json');

      _areaPurchaseFile = File('$localPath/area_purchase.json');

      _settingsFile = File('$localPath/settings.json');

      final inventoryFileExists = await _inventoryFile.exists();

      final spaceshipFileExists = await _spaceshipFile.exists();

      final pickaxeFileExists = await _pickaxeFile.exists();

      final areaPurchaseFileExists = await _areaPurchaseFile.exists();

      final settingsFileExists = await _settingsFile.exists();

      if (!inventoryFileExists) {
        final inventoryData = await rootBundle.loadString(
          'assets/save/inventory.json',
        );

        await _inventoryFile.writeAsString(inventoryData);
      }

      if (!spaceshipFileExists) {
        final spaceshipData = await rootBundle.loadString(
          'assets/save/spaceship.json',
        );

        await _spaceshipFile.writeAsString(spaceshipData);
      }

      if (!pickaxeFileExists) {
        final pickaxeData = await rootBundle.loadString(
          'assets/save/pickaxe.json',
        );

        await _pickaxeFile.writeAsString(pickaxeData);
      }

      if (!areaPurchaseFileExists) {
        final areaPurchaseData = await rootBundle.loadString(
          'assets/save/area_purchase.json',
        );

        await _areaPurchaseFile.writeAsString(areaPurchaseData);
      }

      if (!settingsFileExists) {
        final settingsData = await rootBundle.loadString(
          'assets/save/settings.json',
        );

        await _settingsFile.writeAsString(settingsData);
      }

      _inventory = Inventory.fromJson(
        jsonDecode(_inventoryFile.readAsStringSync()),
      );
      _spaceship = SpaceshipData.fromJson(
        jsonDecode(_spaceshipFile.readAsStringSync()),
      );
      _pickaxe = PickaxeData.fromJson(
        jsonDecode(_pickaxeFile.readAsStringSync()),
      );

      _areaPurchaseData = AreaPurchaseData.fromJson(
        jsonDecode(_areaPurchaseFile.readAsStringSync()),
      );

      _settings = SettingsData.fromJson(
        jsonDecode(_settingsFile.readAsStringSync()),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveInventory() async {
    await _inventoryFile.writeAsString(jsonEncode(inventory.toJson()));
  }

  Future<void> saveSpaceship() async {
    await _spaceshipFile.writeAsString(jsonEncode(_spaceship.toJson()));
  }

  Future<void> savePickaxe() async {
    await _pickaxeFile.writeAsString(jsonEncode(_pickaxe.toJson()));
  }

  Future<void> saveSettings() async {
    await _settingsFile.writeAsString(jsonEncode(_settings.toJson()));
  }

  Future<void> saveAreaPurchase() async {
    await _areaPurchaseFile.writeAsString(
      jsonEncode(_areaPurchaseData.toJson()),
    );
  }

  void saveAll() async {
    await saveInventory();
    await saveSpaceship();
    await savePickaxe();
    await saveAreaPurchase();
    await saveSettings();
  }
}
