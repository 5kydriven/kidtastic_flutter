import 'package:bloc/bloc.dart';
import 'package:kidtastic_flutter/repositories/repositories.dart';
import 'package:kidtastic_flutter/service/audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import 'bloc.dart';

class InitialScreenBloc extends Bloc<InitialScreenEvent, InitialScreenState> {
  final TeacherRepository _teacherRepository;
  final AudioService _audioService = AudioService.instance;

  InitialScreenBloc({
    required InitialScreenState initialState,
    required TeacherRepository teacherRepository,
  }) : _teacherRepository = teacherRepository,
       super(initialState) {
    on<InitialScreenCreated>(_screenCreated);
    on<InitialScreenSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    InitialScreenCreated event,
    Emitter<InitialScreenState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final isBgmMuted = prefs.getBool(BoolPreference.keyIsBgmMuted) ?? false;
    final isSfxMuted = prefs.getBool(BoolPreference.keyIsSfxMuted) ?? false;
    final bgmVolume = prefs.getDouble(DoublePreference.keyBgmVolume) ?? 1.0;
    final sfxVolume = prefs.getDouble(DoublePreference.keySfxVolume) ?? 1.0;

    emit(
      state.copyWith(
        screenRequestStatus: RequestStatus.inProgress,
        isBgmMuted: isBgmMuted,
        isSfxMuted: isSfxMuted,
        bgmVolume: bgmVolume,
        sfxVolume: sfxVolume,
      ),
    );

    final result = await _teacherRepository.getTeacher();

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  Future<void> _sfxButtonPressed(
    InitialScreenSfxButtonPressed event,
    Emitter<InitialScreenState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
