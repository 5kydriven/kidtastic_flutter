class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPasswordScreenCreated extends ForgotPasswordEvent {
  const ForgotPasswordScreenCreated();
}

class ForgotPasswordPasswordChanged extends ForgotPasswordEvent {
  final String value;

  const ForgotPasswordPasswordChanged({
    required this.value,
  });
}

class ForgotPasswordConfirmPasswordChanged extends ForgotPasswordEvent {
  final String value;

  const ForgotPasswordConfirmPasswordChanged({
    required this.value,
  });
}

class ForgotPasswordUsernameChanged extends ForgotPasswordEvent {
  final String value;

  const ForgotPasswordUsernameChanged({
    required this.value,
  });
}

class ForgotPasswordButtonPressed extends ForgotPasswordEvent {
  const ForgotPasswordButtonPressed();
}

class ForgotPasswordNextPressed extends ForgotPasswordEvent {
  const ForgotPasswordNextPressed();
}

class ForgotPasswordObscurePasswordPressed extends ForgotPasswordEvent {
  const ForgotPasswordObscurePasswordPressed();
}

class ForgotPasswordObscureConfirmPasswordPressed extends ForgotPasswordEvent {
  const ForgotPasswordObscureConfirmPasswordPressed();
}

class ForgotPasswordBgmToggled extends ForgotPasswordEvent {
  const ForgotPasswordBgmToggled();
}

class ForgotPasswordSfxToggled extends ForgotPasswordEvent {
  const ForgotPasswordSfxToggled();
}

class ForgotPasswordBgmVolumeChanged extends ForgotPasswordEvent {
  final double volume;

  const ForgotPasswordBgmVolumeChanged({
    required this.volume,
  });
}

class ForgotPasswordSfxVolumeChanged extends ForgotPasswordEvent {
  final double volume;

  const ForgotPasswordSfxVolumeChanged({
    required this.volume,
  });
}

class ForgotPasswordSfxButtonPressed extends ForgotPasswordEvent {
  const ForgotPasswordSfxButtonPressed();
}
