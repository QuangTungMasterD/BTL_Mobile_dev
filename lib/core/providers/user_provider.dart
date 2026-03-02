import 'dart:async';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/profile/data/models/user_model.dart';
import 'package:btl_music_app/features/profile/data/repo/user_repo.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repo;

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription<UserModel>? _subscription;

  UserProvider(this._repo);

  Future<void> initUser() async {
    if (_user != null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _repo.createUserIfNotExists();
      _user = await _repo.getUser();
      debugPrint("UserProvider: Loaded user thành công - ${user?.displayName ?? 'no name'}");
      _startRealtimeListen();
    } catch (e, st) {
      debugPrint("UserProvider init error: $e\n$st");
    }

    _isLoading = false;
    notifyListeners();
  }

  void _startRealtimeListen() {
    _subscription?.cancel();
    _subscription = _repo.userStream().listen(
      (updatedUser) {
        _user = updatedUser;
        notifyListeners();
        debugPrint("UserProvider: Realtime update - ${updatedUser.displayName}");
      },
      onError: (e) => debugPrint("User stream error: $e"),
    );
  }

  Future<void> updateProfile(UserModel updated) async {
    try {
      await _repo.updateUser(updated);
      // Stream sẽ tự cập nhật _user
    } catch (e) {
      debugPrint("Update profile error: $e");
    }
  }

  void clear() {
    _subscription?.cancel();
    _subscription = null;
    _user = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}