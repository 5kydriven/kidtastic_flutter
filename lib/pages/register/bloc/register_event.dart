sealed class RegisterEvent {
  const RegisterEvent();
}

class RegisterScreenCreated extends RegisterEvent {
  const RegisterScreenCreated();
}

class RegisterNameChanged extends RegisterEvent {
  final String name;

  const RegisterNameChanged(this.name);
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged(this.email);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged(this.password);
}
