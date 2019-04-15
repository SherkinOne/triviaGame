import 'package:flutter/material.dart';
import 'questions.dart';
import 'data.dart';

class SavedPage extends StatefulWidget {
  SavedPage({Key key, this.title}) : super(key: key);
  final String title;

  List questions = [];
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  int _selectedIndex = 0;
    final dbHelper = DatabaseHelper.instance;
  var x = 0;
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
                  future : _query() ,
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
    if (index == 0) Navigator.pop(context);
  }


     _buildExpandableContent(SavedQuestions questions) {
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

Future<List<SavedQuestions>> _query() async {
   final dbHelper = DatabaseHelper.instance;
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
  //  allRows.forEach((row) => print(row));

 List<SavedQuestions> quest = [];
      for (var q in allRows) {
        SavedQuestions question = SavedQuestions(q['question'], q["answer"]);
        quest.add(question);
      }
      return quest;
  


  }

 
  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
 
