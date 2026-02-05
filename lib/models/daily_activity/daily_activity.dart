import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_activity.freezed.dart';

@freezed
sealed class DailyActivity with _$DailyActivity {
  const factory DailyActivity({
    required DateTime date,
    required String dayName,
    required int sessionCount,
  }) = _DailyActivity;
}
