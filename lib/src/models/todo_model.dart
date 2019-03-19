import 'package:quiver/core.dart';

class Todo {
  int index;
  bool isActive;
  String header, body;

  Todo._internal(this.index, this.isActive, this.body, this.header);

  Todo.newInstance(this.index,this.body, this.header) {
    this.isActive = false;
  }

  @override
  bool operator ==(other) {
    return other is Todo && other.index == this.index && other.header == this.header && other.body == this.body && other.isActive == this.isActive;
  }

  @override
  int get hashCode {
    return hash4(index.hashCode, isActive.hashCode, header.hashCode, body.hashCode);
  }


}

class TodoTest extends Todo {
  TodoTest(int index, bool isActive, String body, String header) : super.newInstance(index, body, header) {
    this.isActive = isActive;
  }
}