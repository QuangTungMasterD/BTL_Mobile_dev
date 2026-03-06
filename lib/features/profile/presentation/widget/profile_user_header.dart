import 'package:flutter/material.dart';
import 'package:btl_music_app/features/profile/data/models/user_model.dart';
import 'package:btl_music_app/features/profile/presentation/edit_profile_screen.dart';

class ProfileUserHeader extends StatelessWidget {
  final UserModel user;

  const ProfileUserHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.avatar.isNotEmpty
        ? user.avatar
        : "https://images.spiderum.com/sp-images/9ae85f405bdf11f0a7b6d5c38c96eb0e.jpeg";

    final name = user.displayName.isNotEmpty
        ? user.displayName
        : (user.fullName.isNotEmpty ? user.fullName : "Người dùng");

    final status = user.isPremium ? "PREMIUM" : "BASIC";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 45, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
            ),
            child: const Text(
              "Sửa hồ sơ",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}