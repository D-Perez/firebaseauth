import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebaseauth/model/note.dart';

// Creating a notes database class
class NotesDatabase {
  // Creating an instance of the notes database
  static final NotesDatabase instance = NotesDatabase._init();

  // Field for the database
  static Database? _database;

  // Constructor for notes database
  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('notes.db');
    return _database!;
  }

  // Function for initializing the database
  Future <Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join (dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
  CREATE TABLE $tableNotes (
    ${NoteFields.id} $idType,
    ${NoteFields.isImportant}, $boolType,
  ''');
  }

  // Function for closing our data base
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}