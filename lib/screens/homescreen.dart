import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/todoprovider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final todoprovider = Provider.of<Todoprovider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "To-Do App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Write something",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            FloatingActionButton(
              onPressed: () {
                if (_controller.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a todo")),
                  );
                } else {
                  todoprovider.addTodo(_controller.text);
                  _controller.clear();
                }
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: todoprovider.data.isEmpty
                  ? Center(child: Text("No Todos Yet"))
                  : ListView.builder(
                      itemCount: todoprovider.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(todoprovider.data[index].title),
                            onTap: () {
                              TextEditingController _editController =
                                  TextEditingController(
                                    text: todoprovider.data[index].title,
                                  );
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Update Todo"),
                                    content: TextField(
                                      controller: _editController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Edit todo",
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_editController.text.isNotEmpty) {
                                            todoprovider.updateTodo(
                                              index,
                                              _editController.text,
                                            );
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text("Update"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                todoprovider.removeTodo(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
