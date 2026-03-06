import 'package:btl_music_app/features/profile/presentation/widget/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuItem(
          icon: Icons.settings,
          title: "Cài đặt",
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
        MenuItem(
          icon: Icons.notifications,
          title: "Thông báo",
          onTap: () => Navigator.pushNamed(context, '/notify'),
        ),
        MenuItem(
          icon: Icons.logout,
          title: "Đăng xuất",
          onTap: () async {
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
          },
        ),
      ],
    );
  }
}