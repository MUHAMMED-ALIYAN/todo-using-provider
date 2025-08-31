import 'package:flutter/material.dart';
import 'package:my_todo_app/providers/task_provider.dart';
import 'package:provider/provider.dart';



class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Input Box
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter new task...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      taskProvider.addTask(_controller.text);
                      _controller.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                )
              ],
            ),
          ),

          // Task List
          Expanded(
            child: taskProvider.tasks.isEmpty
                ? const Center(child: Text("No tasks yet!"))
                : ListView.builder(
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          taskProvider.deleteTask(index);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 3,
                          child: ListTile(
                            leading: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                              child: task.isCompleted
                                  ? const Icon(Icons.check_circle, color: Colors.green, key: ValueKey(true))
                                  : const Icon(Icons.circle_outlined, color: Colors.grey, key: ValueKey(false)),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.grey : Colors.black,
                              ),
                            ),
                            onTap: () {
                              taskProvider.toggleTask(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
