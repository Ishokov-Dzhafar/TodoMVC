import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        theme: ThemeData.dark(),
        home: Screen()
    );
  }

}

class Screen extends StatelessWidget {

  List<int> array = [1,2,3,4,5,6,7,8,8,9,10,11,12,13,14,15];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Eeeeee"),),
      body: CustomScrollView(
          slivers: <Widget>[
          buildListView(context),
          SliverList(
            delegate: SliverChildListDelegate([
              Text("BLABLABLA"),
              Text("BLABLABLA2"),
              Text("BLABLABLA3"),
            ]),
          )
        ]
        ),
      );
  }


  Widget buildListView(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(array[index].toString()),
            ),
          );
        },
        childCount: array.length,
      ),
    );
  }

  /*Widget buildListView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: array.length,
          itemBuilder: (context, index) {
            return  Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(array[index].toString()),
              ),
            );
          }),
    );
  }*/
}
