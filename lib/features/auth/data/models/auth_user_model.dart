import 'package:firebase_auth/firebase_auth.dart';

class AuthUserModel {
  final String uid;
  final String email;

  AuthUserModel({
    required this.uid,
    required this.email,
  });

  factory AuthUserModel.fromFirebase(User user) {
    return AuthUserModel(
      uid: user.uid,
      email: user.email ?? '',
    );
  }
}