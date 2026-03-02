import 'package:btl_music_app/features/auth/data/models/auth_user_model.dart';
import 'package:flutter/material.dart';
import '../../features/auth/data/repo/auth_repo.dart';

class AuthUserProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthUserProvider(this._authRepository);

  AuthUserModel? _user;
  AuthUserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  Future<void> checkAuth() async {
    _user = _authRepository.currentUser;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _user = await _authRepository.login(email, password);
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    _user = await _authRepository.loginWithGoogle();
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _user = await _authRepository.register(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _user = null;
    notifyListeners();
  }
}