import 'package:demolight/app_utils/global_state.dart';
import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new MyStatefulWidget1(),
            new MyStatefulWidget2(),
          ],
        ),
      ),
    );
  }
}

class MyStatefulWidget1 extends StatefulWidget {
  State createState() => new MyStatefulWidget1State();
}

class MyStatefulWidget1State extends State<MyStatefulWidget1> {
  final titleController = TextEditingController();

  titleTextValue() {
    print("title text field: ${titleController.text}");
    return titleController.text;
  }

  @override
  Widget build(BuildContext context) {
    store.set("titleTextValue", titleTextValue);
    return TextField(controller: titleController);
  }
}

class MyStatefulWidget2 extends StatefulWidget {
  State createState() => new MyStatefulWidget2State();
}

class MyStatefulWidget2State extends State<MyStatefulWidget2> {
  String _text = 'PRESS ME';

  @override
  Widget build(BuildContext context) {
    var titleTextValue = store.get("titleTextValue");
    return new Center(
      child: new RaisedButton(
          child: new Text(_text),
          onPressed: () {
            print('title is ' + titleTextValue());
          }),
    );
  }
}



final GlobalState store = GlobalState.instance;