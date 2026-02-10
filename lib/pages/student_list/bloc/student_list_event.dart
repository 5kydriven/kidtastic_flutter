sealed class StudentListEvent {
  const StudentListEvent();
}

class StudentListScreenCreated extends StudentListEvent {
  const StudentListScreenCreated();
}

class StudentListGameSessionFetched extends StudentListEvent {
  const StudentListGameSessionFetched();
}

class StudentListBgmToggled extends StudentListEvent {
  const StudentListBgmToggled();
}

class StudentListBgmVolumeChanged extends StudentListEvent {
  final double volume;

  const StudentListBgmVolumeChanged({required this.volume});
}

class StudentListSfxToggled extends StudentListEvent {
  const StudentListSfxToggled();
}

class StudentListSfxVolumeChanged extends StudentListEvent {
  final double volume;

  const StudentListSfxVolumeChanged({required this.volume});
}

class StudentListSfxButtonPressed extends StudentListEvent {
  const StudentListSfxButtonPressed();
}

class StudentListDeleteStudentPressed extends StudentListEvent {
  final int id;

  const StudentListDeleteStudentPressed({
    required this.id,
  });
}
