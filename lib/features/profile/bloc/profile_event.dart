import 'package:btl_music_app/features/profile/data/models/user_model.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserModel user;
  UpdateProfile(this.user);
}
