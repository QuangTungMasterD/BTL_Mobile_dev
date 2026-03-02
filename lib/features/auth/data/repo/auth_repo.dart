import 'package:btl_music_app/features/auth/data/models/auth_user_model.dart';
import 'package:btl_music_app/features/auth/data/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(AuthService service) : _service = service;

  AuthUserModel? get currentUser {
    final user = _service.currentUser;
    if (user == null) return null;
    return AuthUserModel.fromFirebase(user);
  }

  Stream<AuthUserModel?> get authStateChanges =>
      _service.authState.map((user) =>
          user == null ? null : AuthUserModel.fromFirebase(user));

  Future<AuthUserModel> login(String email, String password) async {
    try {
      final credential =
          await _service.signInWithEmail(email, password);

      return AuthUserModel.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthUserModel> register(
      String email, String password) async {
    try {
      final credential =
          await _service.registerWithEmail(email, password);

      return AuthUserModel.fromFirebase(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthUserModel> loginWithGoogle() async {
    final credential = await _service.signInWithGoogle();
    return AuthUserModel.fromFirebase(credential.user!);
  }

  Future<void> logout() async {
    await _service.signOut();
  }

  String _handleError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "User not found";
      case 'wrong-password':
        return "Wrong password";
      case 'invalid-email':
        return "Invalid email format";
      case 'email-already-in-use':
        return "Email already exists";
      case 'weak-password':
        return "Password must be at least 6 characters";
      default:
        return "Authentication failed";
    }
  }
}