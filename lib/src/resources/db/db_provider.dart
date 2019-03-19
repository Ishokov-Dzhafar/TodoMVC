
import 'package:todo_app/src/models/todo_model.dart';

abstract class Database {
  Future<int> createTodo(Todo todo);
  Future<List<Todo>> readTodoList();
  Future<int> updateTodo(Todo todo);
  Future<bool> deleteTodo(Todo todo);
}



class TodoDatabase extends Database {

  List<Todo> todoList = [
    TodoTest(0, true, "blabla", "Header1"),
    TodoTest(1, false, "blabla2", "Header2"),
    TodoTest(2, true, "blabla3", "Header3"),
    TodoTest(3, false, "blabla4", "Header14"),
    TodoTest(4, true, "blabla5", "Header15"),
  ];

  var maxRowId = 5;

  @override
  Future<int> createTodo(Todo todo) {
    todo.index = maxRowId;
    todoList.add(todo);
    maxRowId++;
    return Future.value(maxRowId - 1);
  }

  @override
  Future<bool> deleteTodo(Todo todo) {
    todoList.remove(todo);
    return Future.value(true);
  }

  @override
  Future<List<Todo>> readTodoList() {
    return Future.value(todoList);
  }

  @override
  Future<int> updateTodo(Todo todo) {
    int index = todoList.indexWhere((oldTodo) {
      return oldTodo.index == todo.index;
    });
    todoList[index] = todo;
    return Future.value(index);
  }

}


//Singleton
class DBProvider {
  Database _db;
  Database get db => _db;

  static final DBProvider _dbProvider = DBProvider._internal();

  factory DBProvider() {
    return _dbProvider;
  }

  DBProvider._internal() {
    _db = TodoDatabase();
  }
}