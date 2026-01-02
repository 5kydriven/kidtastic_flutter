import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class AudioService {
  AudioService._internal();

  static final AudioService instance = AudioService._internal();

  /* =======================
     Players
     ======================= */

  final AudioPlayer _bgmPlayer = AudioPlayer();

  // Pool for overlapping SFX
  final List<AudioPlayer> _sfxPool = List.generate(4, (_) => AudioPlayer());

  int _sfxIndex = 0;

  /* =======================
     State
     ======================= */

  bool _isBgmMuted = false;
  bool _isSfxMuted = false;
  double _bgmVolume = 1.0;
  double _sfxVolume = 1.0;

  late SharedPreferences _prefs;
  late String _currentBgm;

  bool _initialized = false;

  /* =======================
     Initialization
     ======================= */

  Future<void> init({required String bgmAsset}) async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    _currentBgm = bgmAsset;

    _isBgmMuted = _prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    _isSfxMuted = _prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;

    _bgmVolume = _prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    _sfxVolume = _prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;

    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(_isBgmMuted ? 0 : _bgmVolume);

    for (final player in _sfxPool) {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(_isSfxMuted ? 0 : _sfxVolume);
    }

    if (!_isBgmMuted) {
      await _bgmPlayer.play(AssetSource(_currentBgm));
    }

    _initialized = true;
  }

  /* =======================
     BGM Controls
     ======================= */

  Future<void> muteBgm() async {
    _isBgmMuted = true;
    await _bgmPlayer.setVolume(0);
    await _save();
  }

  Future<void> unmuteBgm() async {
    _isBgmMuted = false;
    await _bgmPlayer.setVolume(_bgmVolume);

    if (_bgmPlayer.state != PlayerState.playing) {
      await _bgmPlayer.play(AssetSource(_currentBgm));
    }

    await _save();
  }

  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);

    if (!_isBgmMuted) {
      await _bgmPlayer.setVolume(_bgmVolume);
    }

    await _save();
  }

  /* =======================
     SFX Controls
     ======================= */

  Future<void> muteSfx() async {
    _isSfxMuted = true;

    for (final player in _sfxPool) {
      await player.setVolume(0);
    }

    await _save();
  }

  Future<void> unmuteSfx() async {
    _isSfxMuted = false;

    for (final player in _sfxPool) {
      await player.setVolume(_sfxVolume);
    }

    await _save();
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);

    if (!_isSfxMuted) {
      for (final player in _sfxPool) {
        await player.setVolume(_sfxVolume);
      }
    }

    await _save();
  }

  Future<void> playSfx(String asset) async {
    if (_isSfxMuted) return;

    final player = _sfxPool[_sfxIndex];
    _sfxIndex = (_sfxIndex + 1) % _sfxPool.length;

    await player.play(
      AssetSource(asset),
      volume: _sfxVolume,
    );
  }

  /* =======================
     Getters
     ======================= */

  bool get isBgmMuted => _isBgmMuted;
  bool get isSfxMuted => _isSfxMuted;
  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;

  /* =======================
     Persistence
     ======================= */

  Future<void> _save() async {
    await _prefs.setBool(BoolPreference.keyIsBgmMuted, _isBgmMuted);
    await _prefs.setBool(BoolPreference.keyIsSfxMuted, _isSfxMuted);
    await _prefs.setDouble(DoublePreference.keyBgmVolume, _bgmVolume);
    await _prefs.setDouble(DoublePreference.keySfxVolume, _sfxVolume);
  }

  /* =======================
     Cleanup (Optional)
     ======================= */

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    for (final player in _sfxPool) {
      await player.dispose();
    }
  }
}
