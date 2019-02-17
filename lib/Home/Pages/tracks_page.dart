import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/Home/bloc/home-page-bloc.dart';
import 'package:musicplayer/Home/model/complete-song-model.dart';
import 'package:musicplayer/Values/static_files.dart';
import 'package:palette_generator/palette_generator.dart';

class TracksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TracksPageState();
}

class TracksPageState extends State<TracksPage>
    with AutomaticKeepAliveClientMixin {
  getSongs() async {
    StaticFiles.audioPlayer = new MusicFinder();
    MusicFinder.allSongs().then((value) {
      setState(() {
        StaticFiles.songsList = value;
      });
      changeSong(StaticFiles.songsList[0].albumArt, StaticFiles.songsList[0]);
      print(StaticFiles.songsList.length);
    }).catchError((e) {
      print('exception caught $e');
    });
  }

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (StaticFiles.songsList != null)
            ? Scrollbar(
                child: ListView.builder(
                    itemCount: StaticFiles.songsList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.pinkAccent,
                              radius: 24.0,
                              child: (Image.asset(
                                          '${StaticFiles.songsList[index].albumArt}') !=
                                      null)
                                  ? ClipOval(
                                      child: SizedBox(
                                      height: 48,
                                      width: 48,
                                      child: Image.asset(
                                        '${StaticFiles.songsList[index].albumArt}',
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                                  : Container(),
                            ),
                            title:
                                Text('${StaticFiles.songsList[index].title}'),
                            onTap: () {
                              setState(() {
                                StaticFiles.currentMusicFileSelectedIndex =
                                    index;
                                StaticFiles.stopMusic();
                                StaticFiles.playMusic();
                                StaticFiles.isSongBeingPlayed = true;
//                                HomeBlocProvider.bloc
//                                    .changeSong(StaticFiles.songsList[index]);
                                changeSong(
                                    (StaticFiles.songsList[index].albumArt !=
                                            null)
                                        ? StaticFiles.songsList[index].albumArt
                                        : Colors.black,
                                    StaticFiles.songsList[index]);
                              });
                            },
                          ),
                          Divider()
                        ],
                      );
                    }),
              )
            : Center(
                child: Text('Loading...'),
              ));
  }

  @override
  bool get wantKeepAlive => true;

  static void changeSong(image, song) async {
    HomeBlocProvider.bloc.changeSongColorDetails(CompleteSongModel(song: song));
    await PaletteGenerator.fromImageProvider(AssetImage(image))
        .then((_paletteGenerator) {
      HomeBlocProvider.bloc.changeSongColorDetails(CompleteSongModel(
          backgroundColor: _paletteGenerator.dominantColor.color,
          textColor: _paletteGenerator.dominantColor.bodyTextColor,
          song: song));
    });
  }
}
