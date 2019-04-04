import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  
  MyApp({Key key, this.questions}) : super(key: key);
  final String questions;
  var no;
  bool isSaved;
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia....',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pub Quiz Questions'),
          centerTitle: true,
        ),
        
        body:   Container (
          child : FutureBuilder(
          future: _getQuestion(), //sets the getQuote method as the expected Future
            builder: (BuildContext context, AsyncSnapshot snapshot) {    
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {  
              if (snapshot.hasData){          
              return  new SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    controller : RefreshController(),
                child : ListView.builder(               
                itemCount : snapshot.data.length,
                scrollDirection: Axis.vertical, 
                itemBuilder :(BuildContext context, int index){
                   no=index+1;
                  return ExpansionTile(              
                    title: Text("${no}. "+snapshot.data[index].question, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                     children: <Widget>[
                      Column(
                        children: _buildExpandableContent(snapshot.data[index]),
                        
              )]                             
              );
            }
            ));
              }
            else {
             return Center(
               child : CircularProgressIndicator()
             );
            }
      }}     
      )
     ))
    );
    }}

      _buildExpandableContent(Questions questions) {
        // This is the expandable part of the tile that shows the answer
    List<Widget> columnContent = [];
      columnContent.add(
        ListTile(
          title: Text(questions.answer, style: TextStyle(fontSize: 18.0),),
        // need a star which add to a saved list (maybe offline??)
         
      ));

            columnContent.add(
              IconButton(
                icon : Icon(Icons.save),
                onPressed : saveQuestion()
        )
      );
    return columnContent;
  }

loadQuestionList(){

  
}

  saveQuestion(){
      // save the question to firebase
      // can be accessible by the other page
    return;
  }

  Future<List<Questions>> _getQuestion() async {
    String url = 'http://jservice.io/api/random?count=20';

    final response =
        await http.get(url, headers: {"Accept": "application/json"});
    
    if (response.statusCode == 200) {
      var theQuestions = jsonDecode(response.body);
      print(response.body);
      List<Questions> quest = [];   
        for (var q in theQuestions){
          Questions questi = Questions(q['question'], q["answer"],false);
          quest.add(questi);
        }
      return quest;
    } else {
        throw Exception('Failed to load post');
   }
  }
  

class Questions {
  Questions(this.question, this.answer, this.saved);

  String question;
  String answer;
  bool saved;

  Questions.fromJson(List <dynamic> json) :
       question = 'question',
        answer = 'answer',
        saved = false;
}