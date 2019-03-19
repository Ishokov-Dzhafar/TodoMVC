import 'package:flutter/material.dart';
import 'package:todo_app/src/blocs/base_bloc.dart';
import 'package:todo_app/src/blocs/todo_bloc.dart';
import 'package:todo_app/src/ui/todo_list_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      home: BlocProvider<TodoBloc> (
        bloc: TodoBloc.db(),
        child: TodoListScreen(),
      )
    );
  }
}