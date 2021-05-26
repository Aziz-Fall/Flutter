import 'package:note/models/Note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  final String noteDatabase = "notes.db";
  final String noteTable = "noteTable";
  final String colTitle = "title";
  final String colDescription = "description";
  final String colDate = 'dateTime';
  final String colId = 'id';

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) _database = await _initializeDatabase();
    return _database;
  }

  Future<Database> _initializeDatabase() async {
    var noteDatabase = openDatabase(
        join(await getDatabasesPath(), this.noteDatabase),
        version: 1,
        onCreate: _createDatabase);

    return noteDatabase;
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''CREATE TABLE $noteTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT,
        $colDescription TEXT,
        $colDate TEXT)''');
  }

  Future<int> insertNote(Note note) async {
    final database = await this.database;
    var result = await database.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    final database = await this.database;
    var result = await database
        .update(noteTable, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    final database = await this.database;
    int result =
        await database.delete(noteTable, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<List<Note>> getListNotes() async {
    final db = await database;
    var maps = await db.query(noteTable);

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> getNoteCount() async {
    final db = await database;
    var data = await db.rawQuery('SELECT COUNT(*) FROM $noteTable');

    return Sqflite.firstIntValue(data);
  }
}
