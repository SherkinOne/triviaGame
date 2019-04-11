import 'package:flutter/material.dart';
import 'questions.dart';

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
  List<SavedQuestions> savedQuest;
  @override
  Widget build(BuildContext context) {
    if (savedQuest == []) {
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
                  itemCount: savedQuest.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    var no = index + 1;
                    return ExpansionTile(
                      title: Text(
                        "$no. " + savedQuest.toString(),
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    );
                  })));
    } else {
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
              child: Center(
                  child: FlatButton(
            child: Text(
              'No Saved Questions\nPlease press to return',
              // thios needs to be reltive to media size
              textScaleFactor: 2.0,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ))));
    }
  }

  void _onItemTapped(int index) {
    _selectedIndex = index;
    if (index == 0) Navigator.pop(context);
  }
}
