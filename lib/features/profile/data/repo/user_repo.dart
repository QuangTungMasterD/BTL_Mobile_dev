import 'package:btl_music_app/features/profile/data/models/user_model.dart';
import 'package:btl_music_app/features/profile/data/service/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<void> createUserIfNotExists() => _service.createUserIfNotExists();

  Future<UserModel> getUser() => _service.getUser();

  Stream<UserModel> userStream() => _service.userStream();

  Future<void> updateUser(UserModel user) => _service.updateUser(user);
}