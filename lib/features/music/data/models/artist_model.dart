class ArtistModel {
  final String id;              // ID document trên Firestore
  final String name;
  final String? avatar;      // Ảnh đại diện
  final String? bio;            // Tiểu sử
  final int followerCount;      // Số người theo dõi

  ArtistModel({
    required this.id,
    required this.name,
    this.avatar,
    this.bio,
    this.followerCount = 0,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> data, String id) {
    return ArtistModel(
      id: id,
      name: data['name'] as String? ?? 'Unknown Artist',
      avatar: data['avatar'] as String?,
      bio: data['bio'] as String?,
      followerCount: (data['followerCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'followerCount': followerCount,
    };
  }

  String get displayName => name;
  String get avatarAr => avatar ?? 'https://via.placeholder.com/150?text=${Uri.encodeComponent(name)}';
}