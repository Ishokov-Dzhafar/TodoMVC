import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_app/src/models/todo_model.dart';
import 'package:todo_app/src/ui/todo_screen.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/base_bloc.dart';

class TodoListScreen extends StatelessWidget {

  TodoBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<TodoBloc>(context);
      return Scaffold(
        appBar: AppBar(
          title: Text('Заметки'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                //Navigate to AddScreen
                _navigateTodoScreen(context, null);
              },
            )
          ],
        ),
        body: buildBody(context),
      );
  }

  Widget buildBody(BuildContext context) {
    return buildWidgetByBloc(context);
  }

  Widget buildWidgetByBloc(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.todoListStream,
      //initialData: List<Todo>(),
      builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
        return Flex(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              flex: 5,
              child: Container(
                child: buildListView(context, snapshot),
              ),
            ),
            Flexible(
              flex: 1,
                child: buildCountContainer()
            )
          ],
        );
      },
    );
  }

  Widget buildCountContainer() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Количетсво выполненных"),
                StreamBuilder(
                  stream: _bloc.countDeactive,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    return Text(snapshot.data.toString());
                  },
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Количетсво невыполненных"),
                StreamBuilder(
                  stream: _bloc.countActive,
                  builder: (context, AsyncSnapshot<int> snapshot) {
                    return Text(snapshot.data.toString());
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
    if(snapshot.data != null) {
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 1.0,
            color: Colors.white70,
          ),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return buildTodoWidget(context, index, snapshot.data[index]);
          }
      );
    } else return Container(width: 0.0, height: 0.0,);
  }


  Widget buildTodoWidget(BuildContext context, int index, Todo todoItem) {
    var textDecoration = todoItem.isActive ? TextDecoration.lineThrough : TextDecoration.none;
    return Dismissible(
      key: Key(todoItem.header+index.toString()),
      onDismissed: (direction) {
        _bloc.todoSink.add(DeleteEvent(todoItem));
      },
      child: GestureDetector(
        onTap: () {
          print("onTap $index");
          _navigateTodoScreen(context, todoItem);
        },
        child: Container(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Checkbox(
                value: todoItem.isActive,
                onChanged: (bool) {
                  todoItem.isActive = !todoItem.isActive;
                  _bloc.todoSink.add(ChangeEvent(todoItem));
                },
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Center(child: Text(todoItem.header, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, decoration: textDecoration),)),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(todoItem.body, style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, decoration: textDecoration),))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  _navigateTodoScreen(BuildContext context, Todo todo) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BlocProvider<TodoBloc> (
        bloc: TodoBloc.db(),
        child:  TodoScreen(todo: todo,),
      );
    }));
    _bloc.todoSink.add(InitEvent(null));
  }

}
