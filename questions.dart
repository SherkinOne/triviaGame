import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'second.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pub Quiz',
      routes: {
        '/': (context) => QuestionsPage(title: 'Pub Quiz Questions'),
     //   '/saved': (context) => SavedPage( title: 'Saved Questions',),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class QuestionsPage extends StatefulWidget {
  QuestionsPage({Key key, this.title}) : super(key: key);
  final String title;
  //final dbHelper = DatabaseHelper.instance;
  List questions = [];
  @override
  _QuestionsPage createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage> {
  // var savedQuestions;
  int _selectedIndex = 0;
  var x = 0;
  final dbHelper = DatabaseHelper.instance;
  List<SavedQuestions> savedQuest;
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
            child: FutureBuilder(
                future:
                _selectedIndex ==0 ? _getQuestion(_selectedIndex) :  _query(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData) {
                      return RefreshIndicator(
                          // could call function that changes state relative to the parameter passed??
                          onRefresh: () async {
                            //async needed else whirly circle stays
                          if (_selectedIndex == 0)
                              setState(() {
                                // _getQuestion();
                                return;
                              });
                          },
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                var no = index + 1;
                                return ExpansionTile(
                                    title: Text(
                                      // check from hereb om wards
                                      "$no. " + snapshot.data[index].question,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    
                                    children: <Widget>[
                                      
                                      Column(
                                        // can is put a if here?  this is causing my problems
                                        children: _selectedIndex ==0 ? _buildExpandableContent(
                                            snapshot.data[index],
                                            _selectedIndex) :
                                            _buildExpandableSavedContent(
                                            snapshot.data[index],
                                            _selectedIndex),
                                     )   
                                    ]);
                              }));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                })));
  }

  void _onItemTapped(int index) {
      _selectedIndex = index;
      setState(() {});

  }

 
 Future<List<SavedQuestions>> _query() async {
    final dbHelper = DatabaseHelper.instance;
    final allRows = await dbHelper.queryAllRows();

    List<SavedQuestions> quest = [];
    for (var q in allRows) {
      SavedQuestions question = SavedQuestions(q['question'], q["answer"]);
      quest.add(question);
    }
    return quest;
  }

Future<List<Questions>> _getQuestion(int theIndex) async {
  if (theIndex == 0) {
    String url = 'http://jservice.io/api/random?count=20';

    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var theQuestions = jsonDecode(response.body);
      List<Questions> quest = [];
      for (var q in theQuestions) {
        Questions question = Questions(q['question'], q["answer"], false);
        quest.add(question);
      }
      return quest;
    } else {
      throw Exception('Failed to load post');
    }
  }
  return [];
}}

class Questions {
  Questions(this.question, this.answer, this.saved);

  String question;
  String answer;
  bool saved;

  Questions.fromJson(List<dynamic> json)
      : question = 'question',
        answer = 'answer',
        saved = false;
}

class TapboxA extends StatefulWidget {
  TapboxA({Key key, this.theQuestion, this.theAnswer, this.theIndex})
      : super(key: key);
  final String theQuestion;
  final String theAnswer;
  final int theIndex;
  @override
  _TapboxAState createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool savedOrNot = false;
  _handleTap() {
    setState(() {
      if (widget.theIndex == 0) {
        if (!savedOrNot) {
          _insert(widget.theQuestion, widget.theAnswer);
        }
        savedOrNot = !savedOrNot;
      } else {
        // delete from the database
        _delete(widget.theQuestion);
        // this is completely random
        savedOrNot = !savedOrNot;
      }
    });
  }

  Widget build(BuildContext context) {
    // This star should be changed if in saved mode
    return IconButton(
      icon: widget.theIndex == 0 ? Icon(Icons.star) : Icon(Icons.delete),
      color:  widget.theIndex == 0 ? savedOrNot ? Colors.red : Colors.green : Colors.blue,
      splashColor: Colors.green,
      highlightColor: Colors.yellow,
      onPressed: _handleTap,
    );
  }

  void _insert(q, a) async {
    final dbHelper = DatabaseHelper.instance;
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnQuestion: q,
      DatabaseHelper.columnAnswer: a
    };
    await dbHelper.insert(row);
  }

  void _delete(q) async {
    // Assuming that the number of rows is the id for the last row.
    final dbHelper = DatabaseHelper.instance;
    await dbHelper.delete(q);
      // then reset state
      }
}


_buildExpandableSavedContent(SavedQuestions questions, int index) {
    List<Widget> columnContent = [];  
    columnContent.add(ListTile(
      title: Text(
        questions.answer,
        style: TextStyle(fontSize: 18.0),
      ),
    ));
    columnContent.add(
      TapboxA(
          theQuestion: questions.question,
          theAnswer: questions.answer),
    );
  
    return columnContent;
  }

  _buildExpandableContent(Questions questions, int index) {
    List<Widget> columnContent = [];
   print("saved");
    columnContent.add(ListTile(
      title: Text(
        questions.answer,
        style: TextStyle(fontSize: 18.0),
      ),
    ));
    columnContent.add(
      TapboxA(
          theQuestion: questions.question,
          theAnswer: questions.answer),
    );
    return columnContent;
  }
  
