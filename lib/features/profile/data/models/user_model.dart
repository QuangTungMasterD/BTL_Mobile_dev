import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String fullName;
  final String phone;
  final String avatar;
  final String bio;
  final bool gender;
  final DateTime? birthday;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.fullName,
    required this.phone,
    required this.avatar,
    required this.bio,
    required this.gender,
    this.birthday,
    this.createdAt,
    this.updatedAt,
  });

  /// Convert Firestore document -> UserModel
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['display_name'] ?? '',
      fullName: data['fullname'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? '',
      bio: data['bio'] ?? '',
      gender: data['gender'] ?? true,
      birthday: (data['birthday'] as Timestamp?)?.toDate(),
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'display_name': displayName,
      'fullname': fullName,
      'phone': phone,
      'avatar': avatar,
      'bio': bio,
      'gender': gender,
      'birthday': birthday,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.empty(String uid, String email) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: '',
      fullName: '',
      phone: '',
      avatar: '',
      bio: '',
      gender: true,
      birthday: null,
      createdAt: null,
      updatedAt: null,
    );
  }
}