sealed class RegisterEvent {
  const RegisterEvent();
}

class RegisterScreenCreated extends RegisterEvent {
  const RegisterScreenCreated();
}

class RegisterNameChanged extends RegisterEvent {
  final String name;

  const RegisterNameChanged({required this.name});
}

class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  const RegisterUsernameChanged({required this.username});
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({required this.password});
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  const RegisterConfirmPasswordChanged({required this.confirmPassword});
}

class RegisterButtonPressed extends RegisterEvent {
  const RegisterButtonPressed();
}

class RegisterObscurePasswordPressed extends RegisterEvent {
  const RegisterObscurePasswordPressed();
}

class RegisterBgmToggled extends RegisterEvent {
  const RegisterBgmToggled();
}

class RegisterSfxToggled extends RegisterEvent {
  const RegisterSfxToggled();
}

class RegisterBgmVolumeChanged extends RegisterEvent {
  final double volume;

  const RegisterBgmVolumeChanged({
    required this.volume,
  });
}

class RegisterSfxVolumeChanged extends RegisterEvent {
  final double volume;

  const RegisterSfxVolumeChanged({
    required this.volume,
  });
}

class RegisterSfxButtonPressed extends RegisterEvent {
  const RegisterSfxButtonPressed();
}
