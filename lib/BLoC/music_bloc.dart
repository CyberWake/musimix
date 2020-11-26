import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/trendingItems.dart';

class MusicBloc {
  final _repository = Repository();
  final _musicFetcher = PublishSubject<trendingItems>();

  Stream<trendingItems> get allMusic => _musicFetcher.stream;

  fetchAllMusic() async {
    trendingItems itemModel = await _repository.fetchAllMusic();
    _musicFetcher.sink.add(itemModel);
  }

  dispose() {
    _musicFetcher.close();
  }
}

final bloc = MusicBloc();