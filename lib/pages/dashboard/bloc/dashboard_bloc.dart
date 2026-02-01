import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import 'bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardState initialState;
  final AudioService _audioService = AudioService.instance;

  DashboardBloc({
    required this.initialState,
  }) : super(initialState) {
    on<DashboardScreenCreated>(_screenCreated);
    on<DashboardSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    DashboardScreenCreated event,
    Emitter<DashboardState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isBgmMuted = prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    final isSfxMuted = prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;
    final bgmVolume = prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    final sfxVolume = prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;

    emit(
      state.copyWith(
        isBgmMuted: isBgmMuted,
        isSfxMuted: isSfxMuted,
        bgmVolume: bgmVolume,
        sfxVolume: sfxVolume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    DashboardSfxButtonPressed event,
    Emitter<DashboardState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
