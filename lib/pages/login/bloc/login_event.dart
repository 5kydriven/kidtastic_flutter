sealed class LoginEvent {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  const LoginButtonPressed();
}

class LoginUsernameChanged extends LoginEvent {
  final String username;

  const LoginUsernameChanged({required this.username});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({required this.password});
}

class LoginObscurePasswordPressed extends LoginEvent {
  const LoginObscurePasswordPressed();
}

class LoginSfxButtonPressed extends LoginEvent {
  const LoginSfxButtonPressed();
}

class LoginBgmToggled extends LoginEvent {
  const LoginBgmToggled();
}

class LoginSfxToggled extends LoginEvent {
  const LoginSfxToggled();
}

class LoginBgmVolumeChanged extends LoginEvent {
  final double volume;

  const LoginBgmVolumeChanged({
    required this.volume,
  });
}

class LoginSfxVolumeChanged extends LoginEvent {
  final double volume;

  const LoginSfxVolumeChanged({
    required this.volume,
  });
}
