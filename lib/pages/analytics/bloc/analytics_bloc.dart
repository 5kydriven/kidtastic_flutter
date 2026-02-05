import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/models/models.dart';
import 'package:kidtastic_flutter/repositories/analytics_repository.dart';

import 'bloc.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository _analyticsRepository;

  AnalyticsBloc({
    required AnalyticsState initialState,
    required AnalyticsRepository analyticsRepository,
  })  : _analyticsRepository = analyticsRepository,
        super(initialState) {
    on<LoadAnalyticsOverview>(_onLoadAnalyticsOverview);
  }

  Future<void> _onLoadAnalyticsOverview(
    LoadAnalyticsOverview event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(screenRequestStatus: RequestStatus.inProgress));

    try {
      final totalStudents = await _analyticsRepository.getTotalStudents();
      final totalSessions = await _analyticsRepository.getTotalSessions();
      final totalMinutesPlayed =
          await _analyticsRepository.getTotalPlayTimeMinutes();
      final averageAccuracy = await _analyticsRepository.getAverageAccuracy();
      final averageAccuracyByGame =
          await _analyticsRepository.getAverageAccuracyByGame();
      final recentSessions = await _analyticsRepository.getRecentSessions();

      final todayStudents = await _analyticsRepository.getTodayStudentCount();
      final todaySessions = await _analyticsRepository.getTodaySessionCount();
      final todayMinutes = await _analyticsRepository.getTodayPlayTimeMinutes();
      final todayAccuracy = await _analyticsRepository.getTodayAverageAccuracy();

      // Phase 2 data
      final topStudents = await _analyticsRepository.getTopStudents();
      final dailyActivity = await _analyticsRepository.getDailyActivity();
      final lowPerformingStudents = await _analyticsRepository.getLowPerformingStudents();
      final inactiveStudents = await _analyticsRepository.getInactiveStudents();

      emit(
        state.copyWith(
          screenRequestStatus: RequestStatus.success,
          totalStudents: totalStudents,
          totalSessions: totalSessions,
          totalMinutesPlayed: totalMinutesPlayed,
          averageAccuracy: averageAccuracy,
          averageAccuracyByGame: averageAccuracyByGame,
          recentSessions: recentSessions,
          studentsChange: todayStudents,
          sessionsChange: todaySessions,
          minutesChange: todayMinutes,
          accuracyChange: todayAccuracy - averageAccuracy,
          topStudents: topStudents,
          dailyActivity: dailyActivity,
          lowPerformingStudents: lowPerformingStudents,
          inactiveStudents: inactiveStudents,
        ),
      );
    } catch (e) {
      emit(state.copyWith(screenRequestStatus: RequestStatus.failure));
    }
  }
}
