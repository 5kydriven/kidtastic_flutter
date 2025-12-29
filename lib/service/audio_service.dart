import 'package:audioplayers/audioplayers.dart';
import 'package:kidtastic_flutter/constants/string_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  AudioService._internal();

  static final AudioService instance = AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMuted = false;
  double _bgmVolume = 1.0;
  double _sfxVolume = 1.0;

  bool _initialized = false;

  /* =======================
     Initialization
     ======================= */

  Future<void> init({required String bgmAsset}) async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();

    _isMuted = prefs.getBool(StringPreference.keyMuted) ?? false;
    _bgmVolume = prefs.getDouble(StringPreference.keyBgmVolume) ?? 1.0;
    _sfxVolume = prefs.getDouble(StringPreference.keySfxVolume) ?? 1.0;

    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);

    await _bgmPlayer.setVolume(_isMuted ? 0 : _bgmVolume);
    await _sfxPlayer.setVolume(_isMuted ? 0 : _sfxVolume);

    if (!_isMuted) {
      await _bgmPlayer.play(AssetSource(bgmAsset));
    }

    _initialized = true;
  }

  /* =======================
     Public API
     ======================= */

  Future<void> mute() async {
    _isMuted = true;
    await _bgmPlayer.setVolume(0);
    await _sfxPlayer.setVolume(0);
    await _save();
  }

  Future<void> unmute() async {
    _isMuted = false;
    await _bgmPlayer.setVolume(_bgmVolume);
    await _sfxPlayer.setVolume(_sfxVolume);
    await _save();
  }

  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _bgmPlayer.setVolume(_bgmVolume);
    }
    await _save();
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _sfxPlayer.setVolume(_sfxVolume);
    }
    await _save();
  }

  Future<void> playSfx(String asset) async {
    if (_isMuted) return;
    await _sfxPlayer.play(
      AssetSource(asset),
      volume: _sfxVolume,
    );
  }

  bool get isMuted => _isMuted;
  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;

  /* =======================
     Persistence
     ======================= */

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StringPreference.keyMuted, _isMuted);
    await prefs.setDouble(StringPreference.keyBgmVolume, _bgmVolume);
    await prefs.setDouble(StringPreference.keySfxVolume, _sfxVolume);
  }

  /* =======================
     Cleanup (Optional)
     ======================= */

  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
