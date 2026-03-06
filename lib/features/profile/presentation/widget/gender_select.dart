import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String gender;
  final ValueChanged<String> onGenderChanged;

  const GenderSelector({
    super.key,
    required this.gender,
    required this.onGenderChanged,
  });

  void _showGenderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ["Nam", "Nữ"].map((g) {
          return ListTile(
            title: Text(g, style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              onGenderChanged(g);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("Giới tính", style: TextStyle(color: Colors.white70)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(gender, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
            ],
          ),
          onTap: () => _showGenderSheet(context),
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}