import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/pages/student_profile/bloc/student_profile_event.dart';
import 'package:kidtastic_flutter/pages/student_profile/bloc/state/student_profile_state.dart';
import 'package:kidtastic_flutter/service/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';

class StudentProfileBloc
    extends Bloc<StudentProfileEvent, StudentProfileState> {
  final AudioService _audioService = AudioService.instance;

  StudentProfileBloc({
    required StudentProfileState initialState,
  }) : super(initialState) {
    on<StudentProfileScreenCreated>(_screenCreated);
    on<StudentProfileSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    StudentProfileScreenCreated event,
    Emitter<StudentProfileState> emit,
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
    StudentProfileSfxButtonPressed event,
    Emitter<StudentProfileState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
