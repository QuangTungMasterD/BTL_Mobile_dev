import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(
            context,
            '/library',
          );
        }
        else if (index == 1) {
          Navigator.pushReplacementNamed(
            context,
            '/home',
          );
        }
        else if (index == 2) {
          Navigator.pushReplacementNamed(
            context,
            '/top',
          );
        }
        else if (index == 3) {
          Navigator.pushReplacementNamed(
            context,
            '/profile',
          );
        }
      },
      type: BottomNavigationBarType.fixed,

      backgroundColor: theme.colorScheme.surface,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: "Thư viện",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Khám phá"),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "Xếp hạng",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
      ],
    );
  }
}
