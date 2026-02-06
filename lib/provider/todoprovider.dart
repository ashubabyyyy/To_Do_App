import 'package:flutter/material.dart';
import 'package:to_do_app/model/todomodel.dart';

class Todoprovider extends ChangeNotifier {
  List<Todomodel> _data = [];
  List<Todomodel> get data => _data;
  
  void addTodo(String title){
    _data.add(Todomodel(title: title));
    notifyListeners();
  }
  void removeTodo(int index){
  _data.removeAt(index);
  notifyListeners();
  }
}
