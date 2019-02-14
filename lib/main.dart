 import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  
  MyApp({Key key, this.questions}) : super(key: key);
  final String questions;
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

                  return ListTile(
                        title : Text(snapshot.data[index].question)

                  );
                }
                                 
              );
            }}
      } )
    )
        
      )
      );
      }}

  Future<List<Questions>> _getQuestion() async {
    String url = 'http://jservice.io/api/random?count=2';
    //String url = 'https://quotes.rest/qod.json';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
    print("Loadoing");
    if (response.statusCode == 200) {
      var theQuestions = jsonDecode(response.body);
      print(response.body);
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
  

  //Map<String, dynamic> to {
    //  'question': question,
     // 'answer': answer,
    //};
}

