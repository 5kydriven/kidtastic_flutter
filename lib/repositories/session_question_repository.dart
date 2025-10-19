import 'package:kidtastic_flutter/daos/session_question_dao/session_question_dao.dart';

class SessionQuestionRepository {
  final SessionQuestionDao _sessionQuestionDao;

  const SessionQuestionRepository({
    required SessionQuestionDao sessionQuestionDao,
  }) : _sessionQuestionDao = sessionQuestionDao;
}
