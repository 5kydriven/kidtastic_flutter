sealed class StudentListEvent {
  const StudentListEvent();
}

class StudentListScreenCreated extends StudentListEvent {
  const StudentListScreenCreated();
}

class StudentListGameSessionFetched extends StudentListEvent {
  const StudentListGameSessionFetched();
}
