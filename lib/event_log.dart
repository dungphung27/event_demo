import 'package:flutter/material.dart';

class EventLog extends StatelessWidget {
  final List<String> items;

  const EventLog({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sự kiện vừa nhận',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty) const Text('Chưa có sự kiện nào. Hãy bấm thử.'),
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  items[i],
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
                    color: i == 0 ? Colors.indigo : Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
