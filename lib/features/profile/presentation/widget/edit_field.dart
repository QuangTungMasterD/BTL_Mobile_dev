import 'package:flutter/material.dart';

class EditableField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType keyboardType;

  const EditableField({
    super.key,
    required this.title,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(color: Colors.white70)),
          subtitle: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint ?? "Chưa có",
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final List<Widget> children;
  const InfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

class ReadonlyField extends StatelessWidget {
  final String title;
  final String value;
  const ReadonlyField({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(color: Colors.white70)),
          trailing: Text(value, style: const TextStyle(color: Colors.white)),
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}


class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AvatarSection extends StatelessWidget {
  final String avatarUrl;

  const AvatarSection({super.key, required this.avatarUrl});

  void _onChangeAvatar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Chức năng đổi ảnh đại diện đang phát triển"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.teal,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _onChangeAvatar(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Đổi ảnh đại diện",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
