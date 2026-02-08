import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/todo_provider.dart';
import '../utils/app_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade900,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        centerTitle: true,
        title: const Text(
          AppStrings.appTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Write something",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                final vm = context.read<TodoViewModel>();
                final success = vm.addTodo(_controller.text);

                if (!success) {
                  _showSnack(AppStrings.emptyTodo);
                } else {
                  _controller.clear();
                }
              },
              child: const Text("SUBMIT"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<TodoViewModel>(
                builder: (_, vm, __) {
                  if (vm.todos.isEmpty) {
                    return const Center(
                      child: Text(
                        AppStrings.noTodos,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: vm.todos.length,
                    itemBuilder: (_, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.task_alt),
                          title: Text(vm.todos[index].title),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.blue),
                                onPressed: () =>
                                    _showEditDialog(vm, index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () =>
                                    vm.deleteTodo(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  void _showEditDialog(TodoViewModel vm, int index) {
    final editController =
        TextEditingController(text: vm.todos[index].title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(AppStrings.updateTodo),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(
            hintText: "Edit todo",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newText = editController.text.trim();

              if (newText.isEmpty) {
                _showSnack(AppStrings.emptyTodo);
                return;
              }

              vm.updateTodo(index, newText);
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
