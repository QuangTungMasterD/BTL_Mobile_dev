abstract class RegisterEvent {}

class RegisterWithEmail extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;
  RegisterWithEmail({required this.email, required this.password, required this.confirmPassword});
}
