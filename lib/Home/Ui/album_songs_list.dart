import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Home/Pages/tracks_page.dart';
import 'package:musicplayer/Values/static_files.dart';

class AlbumSongsList extends StatefulWidget {
  final Song song;
  AlbumSongsList(this.song);
  @override
  _AlbumSongsListState createState() => _AlbumSongsListState();
}

class _AlbumSongsListState extends State<AlbumSongsList> {
  List<Song> songsList = List();
  getAlbumSongList() {
    for (Song song in MusicRepo.songsList) {
      if (song.albumId == widget.song.albumId ||
          song.album == widget.song.album) {
        songsList.add(song);
      }
    }
  }

  @override
  void initState() {
    getAlbumSongList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.album),
      ),
      body: ListView.builder(
          itemCount: songsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                MusicRepo.currentMusicFileSelectedIndex =
                    MusicRepo.songsList.indexOf(songsList[index]);
                MusicRepo.stopMusic();
                MusicRepo.playMusic();
                MusicRepo.isSongBeingPlayed = true;
                changeSong(
                    (songsList[index].albumArt != null)
                        ? songsList[index].albumArt
                        : Colors.black,
                    songsList[index]);
              },
              child: ListTile(
                title: Text(songsList[index].title),
              ),
            );
          }),
    );
  }
}
