import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../service/services.dart';
import 'bloc.dart';

class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  final StudentRepository _studentRepository;
  final GameSessionRepository _gameSessionRepository;
  final AudioService _audioService = AudioService.instance;

  StudentListBloc({
    required StudentListState initialState,
    required StudentRepository studentRepository,
    required GameSessionRepository gameSessionRepository,
  }) : _studentRepository = studentRepository,
       _gameSessionRepository = gameSessionRepository,
       super(initialState) {
    on<StudentListScreenCreated>(_screenCreated);
    on<StudentListGameSessionFetched>(_gameSessionFetched);
    on<StudentListBgmToggled>(_bgmToggled);
    on<StudentListBgmVolumeChanged>(_bgmVolumeChanged);
    on<StudentListSfxToggled>(_sfxToggled);
    on<StudentListSfxVolumeChanged>(_sfxVolumeChanged);
    on<StudentListSfxButtonPressed>(_sfxButtonPressed);
  }

  Future<void> _screenCreated(
    StudentListScreenCreated event,
    Emitter<StudentListState> emit,
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

    final result = await _studentRepository.getStudents();

    switch (result.resultStatus) {
      case ResultStatus.success:
        final studentsData = result.data ?? [];

        // Wait for all lastPlayedAt fetches
        final students = await Future.wait(
          studentsData.map((e) async {
            final lastPlayedAt = await _gameSessionRepository
                .getLastPlayedForStudent(
                  studentId: e.id ?? 0,
                );
            return Student(
              id: e.id,
              name: e.name,
              firstName: e.firstName,
              lastName: e.lastName,
              gender: e.gender,
              image: e.image,
              isSynced: e.isSynced,
              lastPlayedAt: lastPlayedAt.data,
              createdAt: e.createdAt,
            );
          }),
        );

        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.success,
            students: students,
          ),
        );

        add(const StudentListGameSessionFetched());
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

  Future<void> _gameSessionFetched(
    StudentListGameSessionFetched event,
    Emitter<StudentListState> emit,
  ) async {
    emit(
      state.copyWith(
        gameSessionRequestStatus: RequestStatus.inProgress,
      ),
    );

    final result = await _gameSessionRepository.getTodaySessions();

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            gameSessionRequestStatus: RequestStatus.success,
            gameSessions: result.data ?? [],
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            gameSessions: [],
            gameSessionRequestStatus: RequestStatus.failure,
          ),
        );
        break;
    }
  }

  Future<void> _bgmToggled(
    StudentListBgmToggled event,
    Emitter<StudentListState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }
    add(const StudentListSfxButtonPressed());
    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    StudentListBgmVolumeChanged event,
    Emitter<StudentListState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxToggled(
    StudentListSfxToggled event,
    Emitter<StudentListState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const StudentListSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    StudentListSfxVolumeChanged event,
    Emitter<StudentListState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    StudentListSfxButtonPressed event,
    Emitter<StudentListState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }
}
