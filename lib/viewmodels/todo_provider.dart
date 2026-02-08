import 'package:flutter/material.dart';
import 'package:to_do_app/model/todomodel.dart';

class TodoViewModel extends ChangeNotifier {
  final List<Todo> _todos = [];

  List<Todo> get todos => List.unmodifiable(_todos);

  bool addTodo(String title) {
    if (title.trim().isEmpty) return false;
    _todos.add(Todo(title: title));
    notifyListeners();
    return true;
  }

  void deleteTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  bool updateTodo(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return false;
    _todos[index].title = newTitle;
    notifyListeners();
    return true;
  }
}
