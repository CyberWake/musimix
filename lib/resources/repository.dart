import 'dart:async';
import 'package:musix/models/lyrics.dart';

import 'trending_api_provider.dart';
import '../models/trendingItems.dart';

class Repository {
  final musicApiProvider = trendingAPIProvider();

  Future<trendingItems> fetchAllMusic() => musicApiProvider.fetchMusicList();
  Future<lyrics> fetchLyrics(int track_id) => musicApiProvider.fetchLyrics(track_id);
}