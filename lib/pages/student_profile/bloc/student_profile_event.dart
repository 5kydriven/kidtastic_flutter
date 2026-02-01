sealed class StudentProfileEvent {
  const StudentProfileEvent();
}

class StudentProfileScreenCreated extends StudentProfileEvent {
  const StudentProfileScreenCreated();
}

class StudentProfileSfxButtonPressed extends StudentProfileEvent {
  const StudentProfileSfxButtonPressed();
}
