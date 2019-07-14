import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Home/Ui/album_songs_list.dart';
import 'package:musicplayer/Values/static_files.dart';
import 'package:musicplayer/Values/strings.dart';

class AlbumsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AlbumsPageState();
}

class AlbumsPageState extends State<AlbumsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: GridView.count(
          crossAxisCount: 2,
          children: getAlbumList(),
        ),
      ),
    );
  }

  List<Widget> getAlbumList() {
    List<Widget> albumsList = List();
    for (Song song in MusicRepo.songsList) {
      if (song != null) albumsList.add(getAlbumArtWidget(song));
    }
    return albumsList;
  }

  Widget getAlbumArtWidget(Song song) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AlbumSongsList(song)));
            },
            child: (song.albumArt != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      song.albumArt,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.width * 0.4,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              song.album ?? msgAlbum,
              style: TextStyle(fontSize: 16.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
