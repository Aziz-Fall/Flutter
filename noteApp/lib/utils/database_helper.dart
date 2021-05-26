import 'dart:async';
import 'package:noteApp/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _dataBaseHelper; // Singleton DatabaseHelper
  static Database _database; // Sigleton DataBase

  String noteTable = "note_table"; // DataBaseName;
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  //named Constructor to create instance of DataBaseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DatabaseHelper._createInstance();
    }

    return _dataBaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'notes.db';

    //Open/Create the database at a given path
    var notesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TALBE $noteTable("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$colTitle TEXT,"
        "$colDescription TEXT,"
        "$colPriority INTEGER,"
        "$colDate TEXT)");
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // Insert Operation: insert a note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = db.insert(noteTable, note.toMap());

    return result;
  }

  // Delete Operation: Delete a note object from database
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = db.delete(noteTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Update Operation: Update a note object and save it to database
  Future<int> updateNote(Note note) async {
    Database db = await this.database;

    var result = db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);

    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    var req = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(req);

    return result;
  }
}
  