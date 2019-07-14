import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Home/bloc/home-page-bloc.dart';
import 'package:musicplayer/Home/database/sql.dart';
import 'package:musicplayer/Home/model/complete-song-model.dart';
import 'package:musicplayer/Values/static_files.dart';
import 'package:palette_generator/palette_generator.dart';

class TracksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TracksPageState();
}

class TracksPageState extends State<TracksPage>
    with AutomaticKeepAliveClientMixin {
  Sqlite _sqlite = Sqlite();
  getSongs() async {
    MusicRepo.audioPlayer = MusicFinder();
    List<Song> songsList = List();
    songsList = await _sqlite.getSongsFromDatabase();
    if (songsList.length > 0) {
      setState(() {
        MusicRepo.songsList = songsList;
        changeSong(MusicRepo.songsList[0].albumArt, MusicRepo.songsList[0]);
      });
    }
    if (songsList == null || songsList.length == 0) {
      MusicFinder.allSongs().then((value) {
        List<Song> latestSongsList = value;
        latestSongsList.removeWhere((song) => songsList.contains(song));
        MusicRepo.songsList = (MusicRepo.songsList == null)
            ? value
            : (MusicRepo.songsList + (value ?? []));
        latestSongsList = value;
        _sqlite.insertSongsIntoDatabase(latestSongsList);
        if (latestSongsList.length != songsList) {
          setState(() {});
        }
        setState(() {});
      }).catchError((e) {
        print('exception caught $e');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (MusicRepo.songsList != null)
            ? Scrollbar(
                child: ListView.builder(
                    itemCount: MusicRepo.songsList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.pinkAccent,
                              radius: 24.0,
                              child: (Image.asset(
                                          '${MusicRepo.songsList[index].albumArt}') !=
                                      null)
                                  ? ClipOval(
                                      child: SizedBox(
                                      height: 48,
                                      width: 48,
                                      child: Image.asset(
                                        '${MusicRepo.songsList[index].albumArt}',
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                                  : Container(),
                            ),
                            title: Text('${MusicRepo.songsList[index].title}'),
                            onTap: () {
                              setState(() {
                                MusicRepo.currentMusicFileSelectedIndex = index;
                                MusicRepo.stopMusic();
                                MusicRepo.playMusic();
                                MusicRepo.isSongBeingPlayed = true;
                                changeSong(
                                    (MusicRepo.songsList[index].albumArt !=
                                            null)
                                        ? MusicRepo.songsList[index].albumArt
                                        : Colors.black,
                                    MusicRepo.songsList[index]);
                              });
                            },
                          ),
                          Divider()
                        ],
                      );
                    }),
              )
            : Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ));
  }

  @override
  bool get wantKeepAlive => true;
}

void changeSong(image, song) async {
  HomeBlocProvider.bloc.changeSongColorDetails(CompleteSongModel(song: song));

  PaletteGenerator.fromImageProvider(AssetImage(image))
      .then((_paletteGenerator) {
    HomeBlocProvider.bloc.changeSongColorDetails(CompleteSongModel(
        backgroundColor: _paletteGenerator.dominantColor.color,
        textColor: _paletteGenerator.dominantColor.bodyTextColor,
        song: song));
  });
}
