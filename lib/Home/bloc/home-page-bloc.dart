import 'package:rxdart/rxdart.dart';

class HomeBlocProvider {
  static HomeBlocProvider bloc = HomeBlocProvider();
  final _songBloc = BehaviorSubject();
  final _songColorBloc = BehaviorSubject();

  Function get changeSong => _songBloc.sink.add;
  Function get changeSongColorDetails => _songColorBloc.sink.add;

  Stream get songStream => _songBloc.stream;
  Stream get songColorStream => _songColorBloc.stream;
}
