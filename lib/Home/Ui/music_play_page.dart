import 'package:flutter/material.dart';
import 'package:musicplayer/Home/Pages/tracks_page.dart';
import 'package:musicplayer/Home/bloc/home-page-bloc.dart';
import 'package:musicplayer/Home/model/complete-song-model.dart';
import 'package:musicplayer/Values/static_files.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicPlayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MusicPlayPageState();
}

class MusicPlayPageState extends State<MusicPlayPage> {
  PaletteGenerator paletteGenerator;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: HomeBlocProvider.bloc.songColorStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          CompleteSongModel data = snapshot.data;
          return GestureDetector(
            onHorizontalDragEnd: (value) {
              if (value.primaryVelocity < -100) {
                previousSong();
              } else if (value.primaryVelocity > 100) {
                nextSong();
              }
            },
            child: Stack(
              children: <Widget>[
                Container(
                  color: data.backgroundColor,
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 0.05 * MediaQuery.of(context).size.height),
                          width: 0.75 * MediaQuery.of(context).size.width,
                          height: 0.5 * MediaQuery.of(context).size.height,
                          child: (data.song.albumArt != null)
                              ? Container(
                                  child: Image.asset(data.song.albumArt),
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                        color: data.textColor, blurRadius: 16.0)
                                  ]),
                                )
                              : Container(
                                  color: Colors.pinkAccent,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 8.0, right: 8.0),
                          child: Text(
                            data.song.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: data.textColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.song.artist,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: data.textColor, fontSize: 16.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.skip_previous),
                                onPressed: () {
                                  previousSong();
                                },
                              ),
                              IconButton(
                                  icon: (StaticFiles.isSongBeingPlayed)
                                      ? Icon(Icons.pause)
                                      : Icon(Icons.play_arrow),
                                  onPressed: () {
                                    setState(() {
                                      if (StaticFiles.isSongBeingPlayed) {
                                        StaticFiles.pauseMusic();
                                      } else {
                                        StaticFiles.playMusic();
                                      }
                                    });
                                  }),
                              IconButton(
                                icon: Icon(Icons.skip_next),
                                onPressed: () {
                                  nextSong();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          );
        } else {
          return Container(color: Colors.pinkAccent);
        }
      },
    );
  }

  void previousSong() {
    StaticFiles.stopMusic();
    StaticFiles.currentMusicFileSelectedIndex--;
    if (StaticFiles.songsList[StaticFiles.currentMusicFileSelectedIndex] ==
        null) StaticFiles.currentMusicFileSelectedIndex = 0;
    changeSong(
        StaticFiles
            .songsList[StaticFiles.currentMusicFileSelectedIndex].albumArt,
        StaticFiles.songsList[StaticFiles.currentMusicFileSelectedIndex]);
    StaticFiles.playMusic();
  }

  void nextSong() {
    StaticFiles.stopMusic();
    StaticFiles.currentMusicFileSelectedIndex++;
    if (StaticFiles.songsList[StaticFiles.currentMusicFileSelectedIndex] ==
        null) StaticFiles.currentMusicFileSelectedIndex = 0;
    changeSong(
        StaticFiles
            .songsList[StaticFiles.currentMusicFileSelectedIndex].albumArt,
        StaticFiles.songsList[StaticFiles.currentMusicFileSelectedIndex]);
    StaticFiles.playMusic();
  }
}
