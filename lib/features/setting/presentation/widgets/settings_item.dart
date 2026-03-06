import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 16),

            Expanded(child: Text(title, style: theme.textTheme.bodyLarge)),

            trailing ??
                Icon(
                  Icons.chevron_right,
                  // ignore: deprecated_member_use
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
          ],
        ),
      ),
    );
  }
}
