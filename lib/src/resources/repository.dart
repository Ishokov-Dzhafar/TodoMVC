
import 'package:todo_app/src/models/todo_model.dart';
import 'package:todo_app/src/resources/db/db_provider.dart';

abstract class TodoRepository {
  Future<int> store(Todo todo);
  Future<List<Todo>> query(Query query);
  Future<bool> delete(Todo todo);

}

class InMemoryTodoRepository extends TodoRepository {
  final Database _db = TodoDatabase();

  //Create or Update if exist
  @override
  Future<int> store(Todo todo) async {
    if(todo.index == null) {
      return await _db.createTodo(todo);
    } else {
      return await _db.updateTodo(todo);
    }
  }

  //Read
  @override
  Future<List<Todo>> query(Query query) async {
    if (query is GetAll) {
      return await _db.readTodoList();
    }
  }

  //Delete
  @override
  Future<bool> delete(Todo todo) async {
    return await _db.deleteTodo(todo);
  }

}

class DBTodoRepository extends TodoRepository {

  Database _db = DBProvider().db;

  //Create or Update if exist
  @override
  Future<int> store(Todo todo) async {
    if(todo.index == null) {
      return await _db.createTodo(todo);
    } else {
      return await _db.updateTodo(todo);
    }
  }

  //Read
  @override
  Future<List<Todo>> query(Query query) async {
    if (query is GetAll) {
      return await _db.readTodoList();
    }
  }

  //Delete
  @override
  Future<bool> delete(Todo todo) async {
    return await _db.deleteTodo(todo);
  }
}

abstract class Query{}

class GetAll extends Query {}
