import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  List questions = [];
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var savedQuestions;
  int _selectedIndex = 0;
  var x = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple[300],
            centerTitle: true,
            title: (Text(widget.title))),
        
        body: Container(
            child: Center(child: CircularProgressIndicator()) ));
  }


  }

  


}
