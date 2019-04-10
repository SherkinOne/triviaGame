import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'second.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pub Quiz',
      routes: {
        '/': (context) => QuestionsPage(title: 'Pub Quiz Questions'),
        '/saved': (context) => SavedPage(title: 'Saved Questions'),
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

  List questions = [];
  @override
  _QuestionsPage createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage> {
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
                    _getQuestion(_selectedIndex), //sets the getQuestions method as the expected Future
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.hasData) {
                      return RefreshIndicator(
                          // could call function that changes state relative to the parameter passed??
                          onRefresh: () async {
                            //async needed else whirly circle stays
                            if ( _selectedIndex ==0 ) setState(() {
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
                                      "$no. " + snapshot.data[index].question,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    children: <Widget>[
                                      Column(
                                        children: _buildExpandableContent(
                                            snapshot.data[index]),
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
    if (index == 1) {
      Navigator.pushNamed(context, '/saved');
    }
  }

  _buildExpandableContent(Questions questions) {
    /// This is the expandable part of the tile that shows the answer
    List<Widget> columnContent = [];

    columnContent.add(ListTile(
      title: Text(
        questions.answer,
        style: TextStyle(fontSize: 18.0),
      ),
    ));
    columnContent.add(
      TapboxA(theQuestion: questions.question, theAnswer: questions.answer),
    );

    return columnContent;
  }
}

loadQuestionList() {}

Future<List<Questions>> _getQuestion(int theIndex) async {
  print(theIndex);
  if (theIndex==0) {
  String url = 'http://jservice.io/api/random?count=20';

  final response = await http.get(url, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    var theQuestions = jsonDecode(response.body);
    print(response.body);
    List<Questions> quest = [];
    for (var q in theQuestions) {
      Questions questi = Questions(q['question'], q["answer"], false);
      quest.add(questi);
    }
    return quest;
  } else {
    throw Exception('Failed to load post');
  }
  }
  return [];
}

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

class SavedQuestions {
  SavedQuestions(this.question, this.answer);

  String question;
  String answer;

  static get length => null;


}

class TapboxA extends StatefulWidget {
  TapboxA({Key key, this.theQuestion, this.theAnswer}) : super(key: key);
  final String theQuestion;
  final String theAnswer;
  @override
  _TapboxAState createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool savedOrNot = false;

  _handleTap() {
    setState(() {
      print(savedOrNot);
      savedOrNot = !savedOrNot;
      if (!savedOrNot) {
        print(widget.theQuestion);
       // SavedQuestions.add(widget.theQuestion, widget.theQuestion)
        // save to other class
        // or maybe save direct to firebase
      }
    });
  }

  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.star),
      color: savedOrNot ? Colors.red : Colors.green,
      splashColor: Colors.green,
      highlightColor: Colors.yellow,
      onPressed: _handleTap,
    );
  }
}
