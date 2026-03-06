import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/profile/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_profile_screen.dart';

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
                      userProvider.initUser(); // Thử load lại thủ công
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
                _buildHeader(context, user),
                const SizedBox(height: 20),
                _buildPremiumCard(context, user),
                const SizedBox(height: 20),
                _buildMenu(context),
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

  Widget _buildHeader(BuildContext context, UserModel user) {
    final avatarUrl = user.avatar.isNotEmpty
        ? user.avatar
        : "https://i.pravatar.cc/300";

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

  Widget _buildPremiumCard(BuildContext context, UserModel user) {
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

  Widget _buildMenu(BuildContext context) {
    return Column(
      children: [
        _menuItem(Icons.settings, "Cài đặt", () {
          Navigator.pushNamed(context, '/settings');
        }),
        _menuItem(Icons.notifications, "Thông báo", () {
          Navigator.pushNamed(context, '/notify');
        }),
        _menuItem(Icons.logout, "Đăng xuất", () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Xác nhận đăng xuất'),
              content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Đăng xuất'),
                ),
              ],
            ),
          );
          if (shouldLogout == true) {
            await context.read<AuthUserProvider>().logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          }
        }),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        // color: Colors.white54,
      ),
      onTap: onTap,
    );
  }
}
