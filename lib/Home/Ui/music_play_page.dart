import 'package:flutter/material.dart';
import 'package:musicplayer/Home/bloc/home-page-bloc.dart';
import 'package:musicplayer/Home/model/complete-song-model.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicPlayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MusicPlayPageState();
}

class MusicPlayPageState extends State<MusicPlayPage> {
  PaletteGenerator paletteGenerator;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: HomeBlocProvider.bloc.songColorStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          CompleteSongModel data = snapshot.data;
          return Stack(
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
                          style:
                              TextStyle(color: data.textColor, fontSize: 16.0),
                        ),
                      )
                    ],
                  ))
            ],
          );
        } else {
          return Container(color: Colors.pinkAccent);
        }
      },
    );
  }
}
