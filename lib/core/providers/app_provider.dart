import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/core/theme/app_colors.dart';
import 'package:btl_music_app/features/profile/data/repo/user_repo.dart';
import 'package:btl_music_app/features/profile/data/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/auth/data/repo/auth_repo.dart';
import '../../features/auth/data/service/auth_service.dart';
import 'auth_provider.dart';
import 'player_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<AppTheme>(create: (_) => AppTheme()),

    /// Auth Service
    Provider<AuthService>(create: (_) => AuthService()),

    /// Auth Repository
    Provider<AuthRepository>(
      create: (context) => AuthRepository(context.read<AuthService>()),
    ),

    /// Auth Provider
    ChangeNotifierProvider<AuthUserProvider>(
      create: (context) => AuthUserProvider(context.read<AuthRepository>()),
    ),

    /// Global Music Player
    // ChangeNotifierProvider<PlayerProvider>(
    //   create: (_) => PlayerProvider(),
    // ),

    Provider<UserService>(create: (_) => UserService()),

    /// User Repository
    Provider<UserRepository>(
      create: (context) => UserRepository(context.read<UserService>()),
    ),

    /// User Provider
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(context.read<UserRepository>()),
    ),
  ];
}
