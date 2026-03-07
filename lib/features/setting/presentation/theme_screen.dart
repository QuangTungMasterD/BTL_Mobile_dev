import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/setting/bloc/theme_bloc.dart';
import 'package:btl_music_app/features/setting/bloc/theme_event.dart';
import 'package:btl_music_app/features/setting/bloc/theme_state.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giao diện chủ đề")),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return Column(
            children: [
              RadioListTile<ThemeMode>(
                title: const Text("Sáng"),
                value: ThemeMode.light,
                groupValue: state.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeBloc>().add(ChangeTheme(value));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("Tối"),
                value: ThemeMode.dark,
                groupValue: state.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeBloc>().add(ChangeTheme(value));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text("Theo hệ thống"),
                value: ThemeMode.system,
                groupValue: state.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeBloc>().add(ChangeTheme(value));
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
