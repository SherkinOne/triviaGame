import 'package:flutter/material.dart';

import 'second.dart';
import 'questions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pub Quiz',
      routes: {
        '/': (context) => MyHomePage(title: 'Pub Quiz Questions'),
        '/questions': (context) => QuestionsPage(title: 'Pub Quiz Questions'),
        '/saved': (context) => SavedPage(title: 'Saved Questions'),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  double x = 0;
  List questions = [];
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  var savedQuestions;
  List theColors = ['Colors.red', 'Colors.Yellow'];
  @override
  Widget build(BuildContext context) {
    //  if (widget.x == Null) widget.x = 0;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple[300],
            centerTitle: true,
            title: (Text(widget.title))),
        body: Container(
            color: Colors.blueGrey[100],
            child: new AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget _widget) {
                  widget.x = widget.x + 0.02;
                  print(widget.x);
                  if (widget.x > 6.28) animationController.stop();
                  return Transform.rotate(
                      angle: widget.x,
                      child: Container(
                          child: Center(
                        child: FlatButton(
                          child: Text(
                            'Pub Quiz',

                            // thios needs to be reltive to media size
                            textScaleFactor: widget.x * 0.75,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: _changeColor(widget.x)),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/questions');
                          },
                        ),
                      )));
                })));
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _changeColor(x) {
    if (x > 6) return Color.fromRGBO(55, 62, 162, 1);
    if (x > 5) return Color.fromRGBO(55, 62, 162, 0.9);
    if (x > 4) return Color.fromRGBO(55, 62, 162, 0.8);
    if (x > 3) return Color.fromRGBO(55, 62, 162, 0.7);
    if (x > 2) return Color.fromRGBO(55, 62, 162, 0.6);
    if (x > 1) return Color.fromRGBO(55, 62, 162, 0.5);
    if (x > 0) return Color.fromRGBO(55, 62, 162, 0.4);
  }
}
