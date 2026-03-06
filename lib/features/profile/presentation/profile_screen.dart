import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/profile/presentation/widget/menu_list.dart';
import 'package:btl_music_app/features/profile/presentation/widget/premium_card.dart';
import 'package:btl_music_app/features/profile/presentation/widget/profile_user_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Loading
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User null → hiển thị thông báo hoặc fallback
        final user = userProvider.user;
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Đang tải thông tin hồ sơ...\nNếu lâu quá, thử đăng xuất rồi đăng nhập lại.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      userProvider.initUser();
                    },
                    child: const Text("Tải lại"),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [MiniPlayer(), AppBottomNav(currentIndex: 3)],
            ),
          );
        }

        // User có dữ liệu → build động
        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                ProfileHeader(title: 'Hồ sơ'),
                ProfileUserHeader(user: user),
                const SizedBox(height: 20),
                PremiumCard(user: user,),
                const SizedBox(height: 20),
                ProfileMenu(),
              ],
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [MiniPlayer(), AppBottomNav(currentIndex: 3)],
          ),
        );
      },
    );
  }
}
