import 'package:flutter/material.dart';
import 'package:todo_app/src/blocs/base_bloc.dart';
import 'package:todo_app/src/models/todo_model.dart';

import '../blocs/todo_bloc.dart';

class TodoScreen extends StatefulWidget {

  final Todo todo;

  TodoScreen({ this.todo,  Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TodoScreen(todo);
  }
}


class _TodoScreen extends State<TodoScreen> {

  TodoBloc _bloc;
  Todo _todo;
  var _headerController = TextEditingController();
  var _bodyController = TextEditingController();

  _TodoScreen(this._todo) {
    if (_todo != null) {
      _headerController.text = _todo.header;
      _bodyController.text = _todo.body;
    }
  }


  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<TodoBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_todo == null ? 'Добавить зметку' : _todo.header),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_todo == null) _todo = Todo.newInstance(null, _bodyController.text, _headerController.text);
              else {
                _todo.header = _headerController.text;
                _todo.body = _bodyController.text;
              }
              print(_bloc.todoSink == null);
              _bloc.todoSink.add(
                  _todo.index == null ? AddTodoEvent(_todo) : ChangeEvent(_todo)
              );
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<Object>(
        stream: _bloc.todoListStream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    controller: _headerController,
                  ),
                ),
                Container(
                  child: TextField(
                    controller: _bodyController,
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree   https://flutter.dev/docs/cookbook/forms/text-field-changes
    _headerController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

}
