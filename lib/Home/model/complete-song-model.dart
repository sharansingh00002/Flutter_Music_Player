import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

class CompleteSongModel {
  Color backgroundColor;
  Color textColor;
  Song song;
  CompleteSongModel(
      {this.backgroundColor = Colors.black,
      this.textColor = Colors.white,
      this.song});
}
