 import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  
  MyApp({Key key, this.questions}) : super(key: key);
  final String questions;
  int nos;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia....',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('The trivia app'),
        ),
        body:  Container (
    //      child : ListView.builder(
 // itemBuilder: (context, index) {
    child : FutureBuilder(
     future: _getQuestion(), //sets the getQuote method as the expected Future
            builder: (BuildContext context, AsyncSnapshot snapshot) {    
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {  
              if (snapshot.hasData){
               
              return ListView.builder(               
                itemCount : snapshot.data.length,
                itemBuilder :(BuildContext context, int index){
                      nos=index+1;  // This is the number displayed
                  return ListTile(
                        title : Text(nos.toString()+". "+snapshot.data[index].question),
                       // subtitle : Text(snapshot.data[index].answer)
                      onTap :(){
                            // Load fill page with answer
                            Navigator.push(context, 
                            new MaterialPageRoute(
                              builder : (context) => AnswerPage(snapshot.data[index])
                              ));
                      }
                  );
                }
                                 
              );
            }
            else {
              // run cirlcy thinng
              CircularProgressIndicator();
            }}
      } )
    )
        
      )
      );
      }}

  Future<List<Questions>> _getQuestion() async {
    String url = 'http://jservice.io/api/random?count=4';
    //String url = 'https://quotes.rest/qod.json';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var theQuestions = jsonDecode(response.body);
      List<Questions> quest = [];   
        for (var q in theQuestions){
          Questions questi = Questions(q['question'], q["answer"]);
          quest.add(questi);
        }
      return quest;
    } else {
        throw Exception('Failed to load post');
   }
  }
  

class Questions {
  Questions(this.question, this.answer);

  String question;
  String answer;

  Questions.fromJson(List <dynamic> json) :
       question = 'question',
        answer = 'answer';
}


// This is my new page

class AnswerPage extends StatelessWidget {
// it passing over an array
  AnswerPage(this.questa);
  final Questions questa;

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('Menu button');
          },
        ),
       title: Text(questa.question)
        // title: Text(this.questa.question),
   
      ),
      body: new Container(
        color: Colors.white,
     
       child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 Text(               
                    questa.question, 
                    style : TextStyle (color: Colors.blue, fontWeight : FontWeight.bold )
                  ),
                  SizedBox(height: 28.0),
                  Text(
                    questa.answer
                  ),
                  Text (
                    "sdfdsf",
                    style : TextStyle (height : 10),  // This is line height
                    
                  ),
                   new InkWell(
          onTap: () {
            Navigator.pushNamed(context, "YourRoute");
          },
          child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Text("Tap Here"),
          ),
        )
                ],
              ),
        
      ),
      );
    
     // body: Text (this.questions),
  }
}