import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/src/blocs/base_bloc.dart';
import 'package:todo_app/src/models/todo_model.dart';
import 'package:todo_app/src/resources/repository.dart';

abstract class Event {
  final Todo _todo;

  Todo get todo => _todo;
  Event(this._todo);
}

class InitEvent extends Event {
  InitEvent(Todo todo): super(todo);
}

class DeleteEvent extends Event{
  DeleteEvent(Todo todo): super(todo);
}

class ChangeEvent extends Event {
  final Todo todo;

  ChangeEvent(this.todo): super(todo);
}

class AddTodoEvent extends Event {

  AddTodoEvent(Todo todo): super(todo);
}

class TodoBloc extends BlocBase {
  final TodoRepository _todoRepository;

  //final _authorizationController = StreamController<Submit>();
  final _todoListController = BehaviorSubject<Event>();
  Observable<List<Todo>> _todoListStream;
  Observable<int> _countActiveTodo; //Count of completed Todo
  Observable<int> _countInactiveTodo; //Count of not completed Todo
  Observable<List<Todo>> _onlyActiveTodo;
  Observable<List<Todo>> _onlyInactiveTodo;

  Stream<List<Todo>> get todoListStream => _todoListStream;

  StreamSink<Event> get todoSink => _todoListController.sink;
  
  Stream<int> get countActive => _countActiveTodo;
  Stream<int> get countDeactive => _countInactiveTodo;

  Stream<List<Todo>> get onlyActive => _onlyActiveTodo;
  Stream<List<Todo>> get onlyDeactive => _onlyInactiveTodo;

  static inMemory() {
    return TodoBloc(InMemoryTodoRepository());
  }

  static db() {
    return TodoBloc(DBTodoRepository());
  }

  TodoBloc(this._todoRepository) {
    _todoListStream = _todoListController.stream.asyncMap((event) => _changeFromEvent(event));
    _countActiveTodo = _todoListStream.scan<int>((count, value, _) => calculateCount(value, false));
    _countInactiveTodo = _todoListStream.scan<int>((count, value, _) => calculateCount(value, true));
    _onlyActiveTodo = _todoListStream.map((list) => list.where((item) => !item.isActive).toList());
    _onlyInactiveTodo = _todoListStream.map((list) => list.where((item) => item.isActive).toList());
    todoSink.add(InitEvent(null));
  }

  int calculateCount(List<Todo> list, bool isActive) {
    int count = 0;
    list.forEach((item) {
      if(item.isActive == isActive) count++;
    });
    return count;
  }


  Future<List<Todo>> _changeFromEvent(Event event) async {
   if(event is DeleteEvent) {
     await _todoRepository.delete(event.todo);
   }
   else if (event is ChangeEvent) {
     await _todoRepository.store(event.todo);
   }
   else if (event is AddTodoEvent) {
     await _todoRepository.store(event.todo);
   }
   return Future.value(_todoRepository.query(GetAll()));
  }

  dispose() {
    _todoListController.close();
  }

}

//final bloc = TodoBloc();

