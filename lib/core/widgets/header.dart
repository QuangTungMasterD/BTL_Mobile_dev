import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  final String title;

  const ProfileHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Title
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          /// Icons
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),

              /// Notification with red dot
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.pushNamed(context, '/notify');
                    },
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  // Navigator.pushNamed(context, '/search');
                  // Navigator.pushNamed(context, '/search');
                  await context.read<AuthUserProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}