import 'package:flutter/material.dart';
import 'package:btl_music_app/features/profile/data/models/user_model.dart';

class PremiumCard extends StatelessWidget {
  final UserModel user;

  const PremiumCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.isPremium) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.white, size: 30),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Nâng cấp Premium để nghe nhạc không quảng cáo",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("Nâng cấp"),
            ),
          ],
        ),
      ),
    );
  }
}