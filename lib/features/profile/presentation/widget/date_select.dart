import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final String title;
  final DateTime? date;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    required this.title,
    required this.date,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatted = date != null ? DateFormat("dd/MM/yyyy").format(date!) : "Chưa có";
    return Column(
      children: [
        ListTile(
          title: Text(title, style: const TextStyle(color: Colors.white70)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatted, style: const TextStyle(color: Colors.white)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
            ],
          ),
          onTap: () => _pickDate(context),
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}