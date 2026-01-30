import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constants.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../service/services.dart';
import 'bloc.dart';

class GameListBloc extends Bloc<GameListEvent, GameListState> {
  final GameRepository _gameRepository;
  final AudioService _audioService = AudioService.instance;

  GameListBloc({
    required GameRepository gameRepository,
    required GameListState initialState,
  }) : _gameRepository = gameRepository,
       super(initialState) {
    on<GameListScreenCreated>(_screenCreated);
    on<GameListPrevButtonPressed>(_prevButtonPressed);
    on<GameListNextButtonPressed>(_nextButtonPressed);
    on<GameListBgmToggled>(_bgmToggled);
    on<GameListSfxToggled>(_sfxToggled);
    on<GameListBgmVolumeChanged>(_bgmVolumeChanged);
    on<GameListSfxVolumeChanged>(_sfxVolumeChanged);
    on<GameListSfxButtonPressed>(_sfxButtonPressed);
    on<GameListTutorialStarted>(_tutorialStarted);
    on<GameListTutorialNextPressed>(_tutorialNext);
    on<GameListTutorialFinished>(_tutorialFinished);
  }

  Future<void> _screenCreated(
    GameListScreenCreated event,
    Emitter<GameListState> emit,
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
    GameListPrevButtonPressed event,
    Emitter<GameListState> emit,
  ) {
    add(const GameListSfxButtonPressed());
    emit(
      state.copyWith(
        currentPage: state.currentPage - 1,
      ),
    );
  }

  void _nextButtonPressed(
    GameListNextButtonPressed event,
    Emitter<GameListState> emit,
  ) {
    add(const GameListSfxButtonPressed());
    emit(
      state.copyWith(
        currentPage: state.currentPage + 1,
      ),
    );
  }

  Future<void> _bgmToggled(
    GameListBgmToggled event,
    Emitter<GameListState> emit,
  ) async {
    if (state.isBgmMuted) {
      await _audioService.unmuteBgm();
    } else {
      await _audioService.muteBgm();
    }
    add(const GameListSfxButtonPressed());

    emit(
      state.copyWith(
        isBgmMuted: !state.isBgmMuted,
      ),
    );
  }

  Future<void> _sfxToggled(
    GameListSfxToggled event,
    Emitter<GameListState> emit,
  ) async {
    if (state.isSfxMuted) {
      await _audioService.unmuteSfx();
    } else {
      await _audioService.muteSfx();
    }

    add(const GameListSfxButtonPressed());

    emit(
      state.copyWith(
        isSfxMuted: !state.isSfxMuted,
      ),
    );
  }

  Future<void> _bgmVolumeChanged(
    GameListBgmVolumeChanged event,
    Emitter<GameListState> emit,
  ) async {
    await _audioService.setBgmVolume(event.volume);

    emit(
      state.copyWith(
        bgmVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxVolumeChanged(
    GameListSfxVolumeChanged event,
    Emitter<GameListState> emit,
  ) async {
    await _audioService.setSfxVolume(event.volume);

    emit(
      state.copyWith(
        sfxVolume: event.volume,
      ),
    );
  }

  Future<void> _sfxButtonPressed(
    GameListSfxButtonPressed event,
    Emitter<GameListState> emit,
  ) async {
    await _audioService.playSfx(Audios.pop2Wav);
  }

  void _tutorialStarted(
    GameListTutorialStarted event,
    Emitter<GameListState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: GameListTutorialStep.welcome,
      ),
    );
  }

  void _tutorialNext(
    GameListTutorialNextPressed event,
    Emitter<GameListState> emit,
  ) {
    final nextStep = switch (state.tutorialStep) {
      GameListTutorialStep.welcome => GameListTutorialStep.games,
      GameListTutorialStep.games => GameListTutorialStep.finished,
      _ => GameListTutorialStep.finished,
    };

    emit(
      state.copyWith(
        tutorialStep: nextStep,
      ),
    );
  }

  void _tutorialFinished(
    GameListTutorialFinished event,
    Emitter<GameListState> emit,
  ) {
    emit(
      state.copyWith(
        tutorialStep: GameListTutorialStep.none,
      ),
    );
  }
}
