sealed class StudentEvent {
  const StudentEvent();
}

class StudentScreenCreated extends StudentEvent {
  const StudentScreenCreated();
}

class StudentGameSessionFetched extends StudentEvent {
  const StudentGameSessionFetched();
}
