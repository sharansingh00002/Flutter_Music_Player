import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

class StaticFiles {
  static List<Song> songsList;
  static int currentMusicFileSelectedIndex = 0;
  static MusicFinder audioPlayer;
  static bool isSongBeingPlayed = false;
  static Color bgColor = Colors.black;
  static playMusic() {
    audioPlayer.play(songsList[currentMusicFileSelectedIndex].uri);
  }

  static pauseMusic() {
    audioPlayer.pause();
  }

  static stopMusic() {
    audioPlayer.stop();
  }
}
