import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper getinstance() => DBHelper._();
  Database? mDB;

  static final String TABLE_NOTE_NAME = "note";
  static final String COLUMN_NOTE_ID = "note_id";
  static final String COLUMN_NOTE_TITLE = "note_title";
  static final String COLUMN_NOTE_DESC = "note_desc";

  Future<Database> getDB() async {
    mDB ??= await openDB();
    return mDB!;
  }

  Future<Database> openDB() async {
    var appDir = await getApplicationDocumentsDirectory();
    var dbpath = join(appDir.path, "notes.db");
    return openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) {
        db.execute("CREATE TABLE $TABLE_NOTE_NAME("
            "$COLUMN_NOTE_ID INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$COLUMN_NOTE_TITLE TEXT, "
            "$COLUMN_NOTE_DESC TEXT)");
      },
    );
  }

  // Insert table
  Future<bool> addNote({
    required String title,
    required String desc,
  }) async {
    Database db = await getDB();
    int rowsEffected = await db.insert(TABLE_NOTE_NAME, {
      COLUMN_NOTE_TITLE: title,
      COLUMN_NOTE_DESC: desc,
    });
    return rowsEffected > 0;
  }

  // Fetch all notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE_NAME);
    return mData;
  }

  // Update note
  Future<bool> updateNote({
    required String updatedTitle,
    required String updatedDesc,
    required int id,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.update(
      TABLE_NOTE_NAME,
      {
        COLUMN_NOTE_TITLE: updatedTitle,
        COLUMN_NOTE_DESC: updatedDesc,
      },
      where: "$COLUMN_NOTE_ID = ?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  // delete note

  Future<bool> deleteNote({required int id}) async {
    var db = await getDB();
    int rowsEffected = await db.delete(TABLE_NOTE_NAME,
        where: "$COLUMN_NOTE_ID = ?", whereArgs: ['$id']);

    return rowsEffected > 0;
  }
}
