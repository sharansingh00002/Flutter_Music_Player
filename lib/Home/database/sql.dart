import 'dart:async';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:sqflite/sqflite.dart';

class Sqlite {
  Database database;
  Future<bool> initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/SongsDB.db';
// open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Songs (id INTEGER, artist TEXT, title TEXT, album TEXT, albumId INTEGER, duration INTEGER, uri TEXT, albumArt TEXT)');
    });
    return true;
  }

  insertSongsIntoDatabase(List<Song> songsList) async {
    await initializeDatabase();
    await database.transaction(
      (txn) async {
        for (Song song in songsList) {
          String artist = (song.artist ?? '').replaceAll('"', '');
          String title = (song.title ?? '').replaceAll('"', '');
          String album = (song.album ?? '').replaceAll('"', '');
          String uri = (song.uri ?? '').replaceAll('"', '');
          String albumArt = (song?.albumArt ?? '').replaceAll('"', '');

          await txn.rawInsert(
              'INSERT INTO Songs(id, artist, title, album, albumId, duration, uri, albumArt) VALUES(${song.id}, "$artist", "$title", "$album",${song.albumId}, ${song.duration},"$uri", "$albumArt")');
        }
      },
    );
  }

  Future<List<Song>> getSongsFromDatabase() async {
    await initializeDatabase();
    List<Song> songsList = List();
    List<Map> databaseData = await database.rawQuery('SELECT * FROM Songs');
    for (var song in databaseData) {
      songsList.add(Song(
          song['id'],
          song['artist'],
          song['title'],
          song['album'],
          song['albumId'],
          song['duration'],
          song['uri'],
          song['albumArt']));
    }
    return songsList;
  }
}
