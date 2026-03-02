
import 'package:btl_music_app/features/auth/data/models/auth_user_model.dart';
import 'package:flutter/material.dart';

import '../../features/auth/data/repo/auth_repo.dart';

class AuthUserProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthUserModel? _user;
  AuthUserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  AuthUserProvider(this._authRepository) {
  }

  // Các hàm login/register/google/logout giữ nguyên, nhưng KHÔNG cần set _user thủ công nữa
  Future<void> login(String email, String password) async {
    await _authRepository.login(email, password);
    // stream listener sẽ tự cập nhật
  }

  Future<void> loginWithGoogle() async {
    await _authRepository.loginWithGoogle();
  }

  Future<void> register(String email, String password) async {
    await _authRepository.register(email, password);
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  // Giữ hàm checkAuth nếu bạn dùng ở splash hoặc đâu đó
  Future<void> checkAuth() async {
    final current = _authRepository.currentUser;
    _user = current;
    notifyListeners();
  }
}