// Table for the notes
final String tableNotes = 'notes';

// Column names for the table
class NoteFields {
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

// Class for the notes with all its fields

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note ({
  this.id,
  required this.isImportant,
  required this.number,
  required this.title,
  required this.description,
  required this.createdTime,

});
}