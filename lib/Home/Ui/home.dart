import 'package:flutter/material.dart';
import 'package:musicplayer/Home/Pages/albums_page.dart';
import 'package:musicplayer/Home/Pages/tracks_page.dart';
import 'package:musicplayer/Home/Ui/music_play_page.dart';
import 'package:musicplayer/Home/bloc/home-page-bloc.dart';
import 'package:musicplayer/Home/model/complete-song-model.dart';
import 'package:musicplayer/Values/Colors.dart';
import 'package:musicplayer/Values/static_files.dart';
import 'package:musicplayer/Values/strings.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String currentPageTitle = headings[0];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          canvasColor: darkBlue,
          primaryColor: Colors.black,
          accentColor: Colors.black54,
          brightness: Brightness.dark),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            currentPageTitle,
            style: TextStyle(fontSize: 16.0),
          ),
        )),
        body: Stack(
          children: <Widget>[
            PageView(
              onPageChanged: (page) {
                setState(() {
                  currentPageTitle = headings[page];
                });
              },
              children: <Widget>[
                TracksPage(),
                AlbumsPage(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: showBottomSheet,
                onVerticalDragEnd: (_) {
                  showBottomSheet();
                },
                child: StreamBuilder(
                  stream: HomeBlocProvider.bloc.songColorStream,
                  builder: (context, snapshot) {
                    CompleteSongModel data = snapshot.data;
                    return AppBar(
                      backgroundColor:
                          (data != null) ? data.backgroundColor : Colors.black,
                      leading: (MusicRepo.songsList != null)
                          ? FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ClipOval(
                                  child: (snapshot.hasData &&
                                          data.song.albumArt != null)
                                      ? Image.asset(data.song.albumArt)
                                      : Container(
                                          color: Colors.pink,
                                        )))
                          : Icon(Icons.queue_music),
                      title: Text(
                        (snapshot.hasData) ? data.song.title : '',
                        style: TextStyle(
                            fontSize: 14.0,
                            color:
                                (data != null) ? data.textColor : Colors.white),
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: (MusicRepo.isSongBeingPlayed)
                              ? IconButton(
                                  icon: Icon(
                                    Icons.pause,
                                    color: (data != null)
                                        ? data.textColor
                                        : Colors.pink,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      MusicRepo.isSongBeingPlayed = false;
                                    });
                                    MusicRepo.pauseMusic();
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: (data != null)
                                        ? data.textColor
                                        : Colors.pink,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      MusicRepo.isSongBeingPlayed = true;
                                    });
                                    MusicRepo.playMusic();
                                  },
                                ),
                        )
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return MusicPlayPage();
    });
  }
}
