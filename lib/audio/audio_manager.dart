import 'package:flutter_soloud/flutter_soloud.dart';

class AudioManager {
  late final SoLoud _soloud;

  SoLoud get soloud => _soloud;

  SoundHandle? _laserSoundHandle;
  SoundHandle? get laserSoundHandle => _laserSoundHandle;
  void set laserSoundHandle(SoundHandle? laserSoundHandle) =>
      _laserSoundHandle = laserSoundHandle;

  SoundHandle? _digSoundHandle;
  SoundHandle? get digSoundHandle => _digSoundHandle;
  void set digSoundHandle(SoundHandle? digSoundHandle) =>
      _digSoundHandle = digSoundHandle;

  SoundHandle? _clickSoundHandle;
  SoundHandle? get clickSoundHandle => _clickSoundHandle;
  void set clickSoundHandle(SoundHandle? clickSoundHandle) =>
      _clickSoundHandle = clickSoundHandle;

  SoundHandle? _itemCollectSoundHandle;
  SoundHandle? get itemCollectSoundHandle => _itemCollectSoundHandle;
  void set itemCollectSoundHandle(SoundHandle? itemCollectSoundHandle) =>
      _itemCollectSoundHandle = itemCollectSoundHandle;

  late final AudioSource _laserSoundSource;
  AudioSource get laserSoundSource => _laserSoundSource;

  late final AudioSource _digSoundSource;
  AudioSource get digSoundSource => _digSoundSource;

  late final AudioSource _clickSoundSource;
  AudioSource get clickSoundSource => _clickSoundSource;

  late final AudioSource _itemCollectSoundSource;
  AudioSource get itemCollectSoundSource => _itemCollectSoundSource;

  Future<void> load() async {
    _soloud = SoLoud.instance;

    await _soloud.init();

    _laserSoundSource = await soloud.loadAsset('assets/audio/laser-bullet.wav');

    _digSoundSource = await soloud.loadAsset('assets/audio/dig.mp3');

    _itemCollectSoundSource = await soloud.loadAsset(
      'assets/audio/item-collect.wav',
    );

    _clickSoundSource = await soloud.loadAsset('assets/audio/click.wav');
  }
}
