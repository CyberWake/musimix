import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkDatabase {
  static final _databaseName = "Bookmarks.db";
  static final _databaseVersion = 1;
  static final table = 'Bookmarks';
  static final colArtistName = 'artistName';
  static final colTrackName = 'trackName';
  static final colAlbumName = 'albumName';
  static final colExplicit = 'explicit';
  static final colTrackRating = 'trackRating';
  static final colTrackId = 'trackId';

  // make it the only class
  BookmarkDatabase._privateConstructor();
  static final BookmarkDatabase instance =
      BookmarkDatabase._privateConstructor();

  // Create a reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
      return _database;
    }
  }

  // open database if it exists otherwise create a new one
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createTable);
  }

  // Creating new table
  Future _createTable(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $table ($colTrackId INTEGER PRIMARY KEY, $colArtistName TEXT NOT NULL, $colAlbumName TEXT NOT NULL, $colTrackRating TEXT NOT NULL, $colExplicit TEXT NOT NULL, $colTrackName TEXT NOT NULL)''');
  }

  // Create a new entry in table
  Future<int> addEntry(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Get all rows
  Future<List<Map<String, dynamic>>> getAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Delete a row with given url
  Future<int> deleteRow(String trackId) async {
    Database db = await instance.database;
    return await db
        .delete(table, where: '$colTrackId = ?', whereArgs: [trackId]);
  }

  //Check if bookmark exists
  Future<bool> isAlreadyBookmarked(String trackId) async {
    Database db = await instance.database;
    int result = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $table WHERE $colTrackId = ?', [trackId]));
    return result == 0 ? false : true;
  }

  //Get bookmarked column
}
