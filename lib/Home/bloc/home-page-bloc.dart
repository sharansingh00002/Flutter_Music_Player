import 'package:rxdart/rxdart.dart';

class HomeBlocProvider {
  static HomeBlocProvider bloc = HomeBlocProvider();
  final _songColorBloc = BehaviorSubject();

  Function get changeSongColorDetails => _songColorBloc.sink.add;

  Stream get songColorStream => _songColorBloc.stream;
}
