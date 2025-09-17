abstract class InitialScreenEvent {
  const InitialScreenEvent();
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
