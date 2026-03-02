
import 'package:btl_music_app/features/setting/presentation/theme_screen.dart';
import 'package:btl_music_app/features/setting/presentation/widgets/settings_item.dart';
import 'package:btl_music_app/features/setting/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Thiết lập")
      ),
      body: ListView(
        children: [
          SettingsSection(
            children: [
              SettingsItem(
                icon: Icons.play_circle_outline,
                title: "Trình phát nhạc",
                onTap: () {},
              ),
              SettingsItem(
                icon: Icons.palette_outlined,
                title: "Giao diện chủ đề",
                onTap: () {
                  Navigator.pushNamed(context, '/settings/theme');
                },
              ),
              SettingsItem(
                icon: Icons.download_outlined,
                title: "Tải nhạc",
                onTap: () {},
              ),
            ],
          ),

          /// ℹ Nhóm 2
          SettingsSection(
            children: [
              SettingsItem(
                icon: Icons.info_outline,
                title: "Phiên bản",
                trailing: const Text("26.01"),
              ),
              SettingsItem(
                icon: Icons.help_outline,
                title: "Trợ giúp và báo lỗi",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
