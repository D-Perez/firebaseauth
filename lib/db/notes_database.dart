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

  // Creates the database within the system
  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
  CREATE TABLE $tableNotes (
    "${NoteFields.id}" $idType,
    "${NoteFields.isImportant}", $boolType,
    "${NoteFields.number}", $integerType,
    "${NoteFields.title}", $textType,
    "${NoteFields.description}", $textType,
    "${NoteFields.time}", $textType
    )
  ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: NoteFields.values,
      // Secure against SQL injections apparently
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
    // Successful query
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
        tableNotes,
        note.toJson(),
        where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  // Function for closing our data base
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}