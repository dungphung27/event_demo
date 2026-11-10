import 'package:flutter/material.dart';

class AddBar extends StatefulWidget {
  final ValueChanged<String> onAdd;

  const AddBar({super.key, required this.onAdd});

  @override
  State<AddBar> createState() => _AddBarState();
}

class _AddBarState extends State<AddBar> {
  final controller = TextEditingController();
  bool canAdd = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    widget.onAdd(text);
    controller.clear();
    setState(() => canAdd = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (value) {
              setState(() => canAdd = value.trim().isNotEmpty);
            },
            onSubmitted: (_) => submit(),
            decoration: const InputDecoration(
              hintText: 'Nhập việc cần làm',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: canAdd ? submit : null,
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}
