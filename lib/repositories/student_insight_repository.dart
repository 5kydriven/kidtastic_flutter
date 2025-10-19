import 'package:kidtastic_flutter/daos/student_insight_dao/student_insight_dao.dart';

class StudentInsightRepository {
  final StudentInsightDao _studentInsightDao;

  const StudentInsightRepository({
    required StudentInsightDao studentInstightDao,
  }) : _studentInsightDao = studentInstightDao;
}
