import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trivia/main.dart';

class SavedPage extends StatefulWidget {
  SavedPage({Key key, this.title}) : super(key: key);
  final String title;

  List questions = [];
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  int _selectedIndex = 0;
  var x = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.deepPurple[300],
            centerTitle: true,
            title: (Text(widget.title))),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            fixedColor: Colors.deepPurple,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('Home')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.save), title: Text('Saved')),
            ]),
        body: Container(
            child: ListView.builder(
                itemCount: SavedQuestions.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var no = index + 1;
                  //   var it = SavedQuestions.iterator;
                  return ExpansionTile(
                    title: Text(
                      "dfdfd",
                      //    "$no. " + SavedQuestions.question,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  );
                })));
  }

  void _onItemTapped(int index) {
    _selectedIndex = index;
    if (index == 0) Navigator.pop(context);
  }
}
