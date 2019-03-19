// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/main.dart';
import 'package:todo_app/src/app.dart';
import 'package:todo_app/src/blocs/todo_bloc.dart';
import 'package:todo_app/src/models/todo_model.dart';

void main() {
  
  group('TodoMVC', () {

    test("1", () async {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(AddTodoEvent(Todo.newInstance(null, "1234", "1234")));
      bloc.todoListStream.listen((List<Todo> list) {
        expect(list.last.index, 5);
        expect(list.last.isActive, false);
        expect(list.last.header, "1234");
        expect(list.last.body, "1234");
      });
      bloc.dispose();
    });

    test("2", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(AddTodoEvent(Todo.newInstance(null, "1234", "1234")));
      bloc.countDeactive.listen((int count) {
        expect(count, 3);
      });
      bloc.dispose();
    });

    test("3", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(DeleteEvent(TodoTest(0, true, "blabla", "Header1")));
      bloc.todoListStream.listen((List<Todo> list) {
        expect(list.first.index, 1);
        expect(list.first.isActive, false);
        expect(list.first.body, "blabla2");
        expect(list.first.header, "Header2");
      });
      bloc.dispose();
    });

    test("4", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(DeleteEvent(TodoTest(0, true, "blabla", "Header1")));
      bloc.countActive.listen((int count) {
        expect(count, 2);
      });
      bloc.dispose();
    });

    test("5", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(DeleteEvent(TodoTest(1, false, "blabla2", "Header2")));
      bloc.countActive.listen((int count) {
        expect(count, 1);
      });
    });

    test("6", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(InitEvent(null));
      bloc.onlyActive.listen((list) {
        print(list.length);
        expect(list.length, 2);
      });
    });

    test("7", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(InitEvent(null));
      bloc.onlyDeactive.listen((list) {
        print(list.length);
        expect(list.length, 3);
      });
    });

    test("8", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(ChangeEvent(TodoTest(1, true, "blabla2", "Header2"),));
      bloc.countActive.listen((int count) {
        expect(count, 1);
      });
    });

    test("9", () {
      TodoBloc bloc = TodoBloc.inMemory();
      bloc.todoSink.add(ChangeEvent(TodoTest(0, false, "blabla", "Header1"),));
      bloc.countDeactive.listen((int count) {
        expect(count, 2);
      });
    });

  });

}
