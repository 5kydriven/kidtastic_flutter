import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/service/audio_service.dart';

import '../../../constants/constants.dart';
import 'bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardState initialState;
  final AudioService _audioService = AudioService.instance;

  DashboardBloc({
    required this.initialState,
  }) : super(initialState) {
    on<DashboardSfxButtonPressed>(_sfxButtonPressed);
  }

  void _sfxButtonPressed(
    DashboardSfxButtonPressed event,
    Emitter<DashboardState> emit,
  ) {
    _audioService.playSfx(Audios.pop2Wav);
  }
}
