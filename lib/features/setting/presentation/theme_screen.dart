import 'package:btl_music_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giao diện chủ đề"),
      ),
      body: Consumer<AppTheme>(
        builder: (context, themeProvider, child) {
          return Column(
            children: [
              RadioListTile<ThemeMode>(
                title: const Text("Sáng"),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<AppTheme>().setThemeMode(value);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("Tối"),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<AppTheme>().setThemeMode(value);
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("Theo hệ thống"),
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<AppTheme>().setThemeMode(value);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}