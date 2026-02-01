import 'package:intl/intl.dart';

extension IntExtension on int {
  String toDateTimeString({String pattern = 'MMM d, y'}) {
    final date = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat(pattern).format(date);
  }
}
