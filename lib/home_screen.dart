import 'package:flutter/material.dart';
import 'add_bar.dart';
import 'event_log.dart';
import 'task.dart';
import 'task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final tasks = <Task>[
    Task('Đọc tài liệu Flutter'),
    Task('Làm slide báo cáo'),
    Task('Chạy thử demo'),
  ];
  final log = <String>[];

  int get doneCount => tasks.where((t) => t.done).length;

  void addLog(String text) {
    log.insert(0, text);
    if (log.length > 6) log.removeLast();
  }

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title));
      addLog('onPressed → thêm "$title"');
    });
  }

  void toggleTask(int index) {
    setState(() {
      final task = tasks[index];
      task.done = !task.done;
      addLog('onTap → "${task.title}": done = ${task.done}');
    });
  }

  void removeTask(int index) {
    setState(() {
      final title = tasks[index].title;
      tasks.removeAt(index);
      addLog('onDismissed → xóa "$title"');
    });
  }

  void clearDone() {
    setState(() {
      tasks.removeWhere((t) => t.done);
      addLog('onDoubleTap → xóa các việc đã xong');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sự kiện và tương tác trong Flutter')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AddBar(onAdd: addTask),
              const SizedBox(height: 16),
              GestureDetector(
                onDoubleTap: clearDone,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fact_check_outlined, color: Colors.indigo),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'State: ${tasks.length} việc, đã xong $doneCount',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Text('Bấm đúp để dọn'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: tasks.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('Danh sách trống')),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < tasks.length; i++)
                            Dismissible(
                              key: ObjectKey(tasks[i]),
                              onDismissed: (_) => removeTask(i),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: TaskTile(
                                task: tasks[i],
                                onTap: () => toggleTask(i),
                              ),
                            ),
                        ],
                      ),
              ),
              const SizedBox(height: 8),
              EventLog(items: log),
            ],
          ),
        ),
      ),
    );
  }
}
