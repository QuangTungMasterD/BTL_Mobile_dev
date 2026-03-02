import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/features/auth/data/models/auth_user_model.dart';
import 'package:btl_music_app/main.dart'; // để dùng navigatorKey
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/auth/data/repo/auth_repo.dart';

class AuthUserProvider extends ChangeNotifier {
  final AuthRepository _authRepo;

  AuthUserModel? _user;
  AuthUserModel? get user => _user;

  bool get isLoggedIn => _user != null;

  AuthUserProvider(this._authRepo) {
    _authRepo.authStateChanges.listen((authUser) async {
      _user = authUser;
      notifyListeners();

      final ctx = navigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;

      final userProv = Provider.of<UserProvider>(ctx, listen: false);

      if (authUser != null) {
        await userProv.initUser(); // ← TỰ ĐỘNG TẠO + LẤY + LISTEN
      } else {
        userProv.clear();
      }
    });
  }

  Future<void> login(String email, String password) async {
    await _authRepo.login(email, password);
    // Không cần làm gì thêm, stream sẽ trigger
  }

  Future<void> loginWithGoogle() async {
    await _authRepo.loginWithGoogle();
  }

  Future<void> register(String email, String password) async {
    await _authRepo.register(email, password);
  }

  Future<void> logout() async {
    await _authRepo.logout();
  }

  Future<void> checkAuth() async {
    final current = _authRepo.currentUser;
    _user = current;
    notifyListeners();

    if (current != null) {
      final ctx = navigatorKey.currentContext;
      if (ctx != null && ctx.mounted) {
        Provider.of<UserProvider>(ctx, listen: false).initUser();
      }
    }
  }
}