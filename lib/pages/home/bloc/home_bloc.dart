import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../service/services.dart';
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GameRepository _gameRepository;
  final AudioService _audioService = AudioService.instance;

  HomeBloc({
    required GameRepository gameRepository,
    required HomeState initialState,
  }) : _gameRepository = gameRepository,
       super(initialState) {
    on<HomeScreenCreated>(_screenCreated);
    on<HomePrevButtonPressed>(_prevButtonPressed);
    on<HomeNextButtonPressed>(_nextButtonPressed);
    on<HomeBgmToggled>(_bgmToggled);
    on<HomeSfxToggled>(_sfxToggled);
    on<HomeBgmVolumeChanged>(_bgmVolumeChanged);
    on<HomeSfxVolumeChanged>(_sfxVolumeChanged);
    on<HomeSfxButtonPressed>(_sfxButtonPressed);
    on<HomeTutorialStarted>(_tutorialStarted);
    on<HomeTutorialNextPressed>(_tutorialNext);
    on<HomeTutorialFinished>(_tutorialFinished);
  }

  Future<void> _screenCreated(
    HomeScreenCreated event,
    Emitter<HomeState> emit,
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

    final result = await _gameRepository.getGames();

    switch (result.resultStatus) {
      case ResultStatus.success:
        emit(
          state.copyWith(
            games: result.data ?? [],
            screenRequestStatus: RequestStatus.success,
          ),
        );
        break;
      default:
        emit(
          state.copyWith(
            screenRequestStatus: RequestStatus.failure,
            games: [],
          ),
        );
        break;
    }
  }

  void _prevButtonPressed(
    HomePrevButtonPressed event,
    Emitter<HomeState> emit,
  ) {
    add(const HomeSfxButtonPressed());
    emit(
      state.copyWith(
        currentPage: state.currentPage - 1,
      ),
    );
  }

  void _nextButtonPressed(
    HomeNextButtonPressed event,
    Emitter<HomeState> emit,
  ) {
    add(const HomeSfxButtonPressed());
    emit(
      state.copyWith(
        currentPage: state.currentPage + 1,
      ),
    );
  }

  Future<void> _bgmToggled(
    HomeBgmToggled event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }
    add(const HomeSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    HomeSfxToggled event,
    Emitter<HomeState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const HomeSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    HomeBgmVolumeChanged event,
    Emitter<HomeState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    HomeSfxVolumeChanged event,
    Emitter<HomeState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    HomeSfxButtonPressed event,
    Emitter<HomeState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }

  void _tutorialStarted(
    HomeTutorialStarted event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: HomeTutorialStep.welcome,
      ),
    );
  }

  void _tutorialNext(
    HomeTutorialNextPressed event,
    Emitter<HomeState> emit,
  ) {
    final nextStep = switch (state.tutorialStep) {
      HomeTutorialStep.welcome => HomeTutorialStep.games,
      HomeTutorialStep.games => HomeTutorialStep.finished,
      _ => HomeTutorialStep.finished,
    };

    emit(
      state.copyWith(
        tutorialStep: nextStep,
      ),
    );
  }

  void _tutorialFinished(
    HomeTutorialFinished event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: HomeTutorialStep.none,
      ),
    );
  }
}
