import 'package:btl_music_app/core/providers/artist_provider.dart';
import 'package:btl_music_app/core/providers/love_list_provider.dart';
import 'package:btl_music_app/core/providers/play_list_provider.dart'; // ← Thêm dòng này
import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/core/theme/app_colors.dart';
import 'package:btl_music_app/features/auth/data/repo/auth_repo.dart';
import 'package:btl_music_app/features/auth/data/service/auth_service.dart';
import 'package:btl_music_app/features/library/data/repo/love_list_repo.dart';
import 'package:btl_music_app/features/library/data/services/love_list_service.dart';
import 'package:btl_music_app/features/music/data/repo/artist_repo.dart';
import 'package:btl_music_app/features/library/data/repo/play_list_repo.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:btl_music_app/features/music/data/services/artist_service.dart';
import 'package:btl_music_app/features/library/data/services/play_list_service.dart';
import 'package:btl_music_app/features/music/data/services/song_service.dart';
import 'package:btl_music_app/features/profile/data/repo/user_repo.dart';
import 'package:btl_music_app/features/profile/data/service/user_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'auth_provider.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<AppTheme>(create: (_) => AppTheme()),

    /// Auth
    Provider<AuthService>(create: (_) => AuthService()),
    Provider<AuthRepository>(
      create: (context) => AuthRepository(context.read<AuthService>()),
    ),
    ChangeNotifierProvider<AuthUserProvider>(
      create: (context) => AuthUserProvider(context.read<AuthRepository>()),
    ),

    /// User
    Provider<UserService>(create: (_) => UserService()),
    Provider<UserRepository>(
      create: (context) => UserRepository(context.read<UserService>()),
    ),
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(context.read<UserRepository>()),
    ),

    /// Song
    Provider<SongService>(create: (_) => SongService()),
    Provider<SongRepository>(
      create: (context) => SongRepository(context.read<SongService>()),
    ),
    ChangeNotifierProvider<SongProvider>(
      create: (context) => SongProvider(context.read<SongRepository>()),
    ),

    /// Artist
    Provider<ArtistService>(create: (_) => ArtistService()),
    Provider<ArtistRepository>(
      create: (context) => ArtistRepository(context.read<ArtistService>()),
    ),
    ChangeNotifierProvider<ArtistProvider>(
      create: (context) => ArtistProvider(context.read<ArtistRepository>()),
    ),

    /// ==================== PLAYLIST ====================
    Provider<PlayListService>(create: (_) => PlayListService()),

    Provider<PlayListRepository>(
      create: (context) => PlayListRepository(context.read<PlayListService>()),
    ),

    ChangeNotifierProxyProvider<AuthUserProvider, PlayListProvider>(
      create: (context) =>
          PlayListProvider(context.read<PlayListRepository>(), ''),
      update: (context, authProvider, previous) {
        final userId = authProvider.user?.uid ?? '';
        if (previous?.userId != userId) {
          return PlayListProvider(context.read<PlayListRepository>(), userId);
        }
        return previous!;
      },
    ),

    /// =================================================

    // Player (nếu đã có)
    ChangeNotifierProvider<PlayerProvider>(create: (_) => PlayerProvider()),
    Provider<LoveListService>(create: (_) => LoveListService()),

    Provider<LoveListRepository>(
      create: (context) => LoveListRepository(context.read<LoveListService>()),
    ),

    ChangeNotifierProxyProvider<AuthUserProvider, LoveListProvider>(
      create: (context) =>
          LoveListProvider(context.read<LoveListRepository>(), ''),
      update: (context, authProvider, previous) {
        final userId = authProvider.user?.uid ?? '';
        if (previous?.userId != userId) {
          return LoveListProvider(context.read<LoveListRepository>(), userId);
        }
        return previous!;
      },
    ),
  ];
}
