abstract class LoginEvent {}

class LoginWithEmail extends LoginEvent {
  final String email;
  final String password;
  LoginWithEmail({required this.email, required this.password});
}

class LoginWithGoogle extends LoginEvent {}
