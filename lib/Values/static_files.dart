import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

class StaticFiles {
  static List<Song> songsList;
  static int currentMusicFileSelectedIndex = 0;
  static MusicFinder audioPlayer;
  static bool isSongBeingPlayed = false;
  static Color bgColor = Colors.black;
  static playMusic() {
    isSongBeingPlayed = true;
    audioPlayer.play(songsList[currentMusicFileSelectedIndex].uri);
  }

  static pauseMusic() {
    isSongBeingPlayed = false;
    audioPlayer.pause();
  }

  static stopMusic() {
    isSongBeingPlayed = false;
    audioPlayer.stop();
  }
}
