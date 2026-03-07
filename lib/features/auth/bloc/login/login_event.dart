abstract class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged(this.password);
}

class TogglePasswordVisibility extends LoginEvent {}

class LoginWithEmail extends LoginEvent {}

class LoginWithGoogle extends LoginEvent {}
