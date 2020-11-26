import 'dart:async';
import 'trending_api_provider.dart';
import '../models/trendingItems.dart';

class Repository {
  final musicApiProvider = trendingAPIProvider();

  Future<trendingItems> fetchAllMusic() => musicApiProvider.fetchMusicList();
}