import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/provider/todoprovider.dart';

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
        title: Center(
          child: Text(
            "To_Do_App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Write something",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            backgroundColor: Colors.grey.shade300,
            onPressed: () {
              if (_controller.text.isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Please fill the form")));
              } else {
                todoprovider.addTodo(_controller.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Added"),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
          todoprovider.data.isEmpty
              ? Text("")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: todoprovider.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(todoprovider.data[index].title),
                      trailing: IconButton(
                        onPressed: () {
                          todoprovider.removeTodo(index);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
