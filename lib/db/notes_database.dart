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
    // Returns the database if it already exists
    if (_database != null) return _database!;

    // Initializes the database if it does not exist and returns it
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Function for initializing the database
  Future<Database> _initDB(String filePath) async {
    // Gets the file path for the databases
    final dbPath = await getDatabasesPath();
    // Creates the entire filepath for the database
    final path = join(dbPath, filePath);

    // Opens the database using the path, version number, and the database schema
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
  ${NoteFields.id} $idType,
  ${NoteFields.isImportant} $boolType,
  ${NoteFields.number} $integerType,
  ${NoteFields.title} $textType,
  ${NoteFields.description} $textType,
  ${NoteFields.time} $textType
  )
''');
  }


  // Function to create a note object in the database
  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }


  // Function to read a note object from the database
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

  // Returns all the notes in the database by ascending order
  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  // Updates a note that exists within the database
  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
        tableNotes,
        note.toJson(),
        where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }


  // Function to delete a note from the database
  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  // Function for closing our database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}