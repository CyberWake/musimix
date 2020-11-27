import 'dart:async';

import 'package:musix/models/lyrics.dart';

import '../models/trendingItems.dart';
import 'trending_api_provider.dart';

class Repository {
  final musicApiProvider = TrendingAPIProvider();

  Future<TrendingItems> fetchAllMusic() => musicApiProvider.fetchMusicData();
  Future<Lyrics> fetchLyrics(int track_id) =>
      musicApiProvider.fetchLyricsData(track_id);
}
