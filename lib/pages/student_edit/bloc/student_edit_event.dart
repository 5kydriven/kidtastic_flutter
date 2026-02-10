import '../../../../models/models.dart';

sealed class StudentEditEvent {
  const StudentEditEvent();
}

class StudentEditScreenCreated extends StudentEditEvent {
  final Student student;

  const StudentEditScreenCreated({
    required this.student,
  });
}

class StudentEditFirstNameChanged extends StudentEditEvent {
  final String value;

  const StudentEditFirstNameChanged({
    required this.value,
  });
}

class StudentEditLastNameChanged extends StudentEditEvent {
  final String value;

  const StudentEditLastNameChanged({
    required this.value,
  });
}

class StudentEditGenderChanged extends StudentEditEvent {
  final String value;

  const StudentEditGenderChanged({
    required this.value,
  });
}

class StudentEditAvatarSelected extends StudentEditEvent {
  final String avatar;

  const StudentEditAvatarSelected({
    required this.avatar,
  });
}

class StudentEditSavePressed extends StudentEditEvent {
  const StudentEditSavePressed();
}

class StudentEditErrorTypeCleared extends StudentEditEvent {
  const StudentEditErrorTypeCleared();
}

class StudentEditSfxButtonPressed extends StudentEditEvent {
  const StudentEditSfxButtonPressed();
}
