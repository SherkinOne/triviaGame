import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableQuestions = 'questions';
final String columnId = '_id';
final String columnQuestion = 'word';
final String columnAnswer = 'frequency';

// data model class
class SavedQuestions {
 // SavedQuestions(this.question, this.answer);

  String question;
  String answer;
  int id;

  SavedQuestions ();

  // convenience constructor to create a Word object
  SavedQuestions.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    question = map[columnQuestion];
    answer = map[columnAnswer];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnQuestion: question, columnAnswer: answer};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "questions.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableQuestions (
                $columnId INTEGER PRIMARY KEY,
                $columnQuestion TEXT NOT NULL,
                $columnAnswer INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert (SavedQuestions word) async {
    Database db = await database;
    int id = await db.insert(tableQuestions, word.toMap());
    return id;
  }

  Future<SavedQuestions> queryQuestion() async {
    Database db = await database;
    List<Map> maps = await db.query(tableQuestions,
        columns: [columnId, columnQuestion, columnAnswer];
   //     where: '$columnId = ?',
  //      whereArgs: [id]);
    if (maps.length > 0) {
      return SavedQuestions.fromMap(maps.first);
    }
    return null;
  }

  // TODO: queryAllWords()
  // TODO: update(Word word)

  Future<void> deleteQuestion(int id) async {
    // Get a reference to the database
    final db = await database;

    // Remove the Dog from the Database
    await db.delete(
      '$tableQuestions',
      // Use a `where` clause to delete a specific dog
      where: "id = ?",
      // Pass the Dog's id through as a whereArg to prevent SQL injection
      whereArgs: [id],
    );
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    SavedQuestions questions = await helper.queryWord(rowId);
    if (questions == null) {
      print('read row $rowId: empty');
    } else {
      print('read row $rowId: ${questions.question} ${questions.answer}');
    }
  }

  _save() async {
   SavedQuestions word = SavedQuestions();
    word.question = 'hello';
    word.answer = "15";
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(word);
    print('inserted row: $id');
  }
}
