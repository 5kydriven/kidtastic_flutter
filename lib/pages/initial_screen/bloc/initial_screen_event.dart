abstract class InitialScreenEvent {
  const InitialScreenEvent();
}

class InitialScreenScreenCreated extends InitialScreenEvent {
  const InitialScreenScreenCreated();
}

class InitialScreenAddStudentPressed extends InitialScreenEvent {
  const InitialScreenAddStudentPressed();
}

class InitialScreenNameChanged extends InitialScreenEvent {
  final String value;

  const InitialScreenNameChanged({
    required this.value,
  });
}

class InitialScreenDeleteStudentPressed extends InitialScreenEvent {
  final int id;

  const InitialScreenDeleteStudentPressed({
    required this.id,
  });
}

class InitialScreenNextButtonPressed extends InitialScreenEvent {
  const InitialScreenNextButtonPressed();
}

class InitialScreenPrevButtonPressed extends InitialScreenEvent {
  const InitialScreenPrevButtonPressed();
}
