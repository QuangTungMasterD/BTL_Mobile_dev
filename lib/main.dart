import 'package:btl_music_app/core/database/database_helper.dart';
import 'package:btl_music_app/core/providers/app_provider.dart';
import 'package:btl_music_app/features/auth/presentation/login_screen.dart';
import 'package:btl_music_app/features/home/presentation/home_screen.dart';
import 'package:btl_music_app/features/library/presentation/library_screen.dart';
import 'package:btl_music_app/features/notify/presentation/notify_screen.dart';
import 'package:btl_music_app/features/playing/presentation/playing_screen.dart';
import 'package:btl_music_app/features/profile/presentation/edit_profile_screen.dart';
import 'package:btl_music_app/features/profile/presentation/profile_screen.dart';
import 'package:btl_music_app/features/search/presentation/search_screen.dart';
import 'package:btl_music_app/features/setting/bloc/theme_bloc.dart';
import 'package:btl_music_app/features/setting/bloc/theme_event.dart';
import 'package:btl_music_app/features/setting/bloc/theme_state.dart';
import 'package:btl_music_app/features/setting/presentation/setting_screen.dart';
import 'package:btl_music_app/features/setting/presentation/theme_screen.dart';
import 'package:btl_music_app/features/splash/splash_screen.dart';
import 'package:btl_music_app/features/top/presentation/top_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: BlocProvider(
        create: (context) => ThemeBloc()..add(LoadTheme()),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: state.lightTheme,
              darkTheme: state.darkTheme,
              themeMode: state.themeMode,
              initialRoute: "/",
              routes: {
                '/': (_) => SplashScreen(),
                '/home': (_) => HomeScreen(),
                '/login': (_) => LoginScreen(),
                '/settings': (_) => SettingsScreen(),
                '/search': (_) => SearchLandingScreen(),
                '/settings/theme': (_) => ThemeScreen(),
                '/playing': (_) => PlayingScreen(),
                '/notify': (_) => NotifyScreen(),
                '/library': (_) => LibraryScreen(),
                '/top': (_) => ChartScreen(),
                '/profile': (_) => ProfileScreen(),
                '/edit-profile': (_) => EditProfileScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}