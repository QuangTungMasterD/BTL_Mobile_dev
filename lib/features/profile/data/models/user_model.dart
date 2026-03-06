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
  final bool isPremium;

  const UserModel({
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
    this.isPremium = false,
  });

  // ===============================
  // FROM FIRESTORE
  // ===============================

  factory UserModel.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("User document does not exist");
    }

    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['display_name'] ?? '',
      fullName: data['fullname'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? 'https://images.spiderum.com/sp-images/9ae85f405bdf11f0a7b6d5c38c96eb0e.jpeg',
      bio: data['bio'] ?? '',
      gender: data['gender'] ?? true, // mặc định male
      birthday: (data['birthday'] as Timestamp?)?.toDate(),
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
      isPremium: data['is_premium'] ?? false,
    );
  }

  // ===============================
  // CREATE MAP
  // ===============================

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'display_name': displayName,
      'fullname': fullName,
      'phone': phone,
      'avatar': avatar,
      'bio': bio,
      'gender': gender,
      'birthday': birthday != null ? Timestamp.fromDate(birthday!) : null,
      'is_premium': isPremium,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  // ===============================
  // UPDATE MAP
  // ===============================

  Map<String, dynamic> toUpdateMap() {
    return {
      'display_name': displayName,
      'fullname': fullName,
      'phone': phone,
      'avatar': avatar,
      'bio': bio,
      'gender': gender,
      'birthday': birthday != null ? Timestamp.fromDate(birthday!) : null,
      'is_premium': isPremium,
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  // ===============================
  // EMPTY USER
  // ===============================

  factory UserModel.empty(String uid, String email) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: '',
      fullName: '',
      phone: '',
      avatar: 'https://images.spiderum.com/sp-images/9ae85f405bdf11f0a7b6d5c38c96eb0e.jpeg',
      bio: '',
      gender: true,
      birthday: null,
      createdAt: null,
      updatedAt: null,
      isPremium: false,
    );
  }

  UserModel copyWith({
    String? displayName,
    String? fullName,
    String? phone,
    String? avatar,
    String? bio,
    bool? gender,
    DateTime? birthday,
    bool? isPremium,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
