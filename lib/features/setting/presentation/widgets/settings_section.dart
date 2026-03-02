import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ...children,
        Divider(
          height: 1,
          color: theme.dividerColor.withOpacity(0.2),
        ),
      ],
    );
  }
}