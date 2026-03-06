import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:btl_music_app/features/setting/bloc/theme_event.dart';
import 'package:btl_music_app/features/setting/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeModeKey = 'theme_mode';

  ThemeBloc() : super(ThemeState(ThemeMode.system)) {
    _loadThemeMode();
    on<ChangeTheme>((event, emit) async {
      emit(ThemeState(event.themeMode));
      _saveThemeMode(event.themeMode);
    });
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    emit(ThemeState(ThemeMode.values[index]));
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }
}