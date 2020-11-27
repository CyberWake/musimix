import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client;

import '../models/lyrics.dart';
import '../models/trendingItems.dart';

class TrendingAPIProvider {
  Client client = Client();

  Future<TrendingItems> fetchMusicList() async {
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=b9c5109c29515a0e2633d5916548f95a");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return TrendingItems.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Lyrics> fetchLyrics(int track_id) async {
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$track_id&apikey=b9c5109c29515a0e2633d5916548f95a");

    if (response.statusCode == 200) {
      return Lyrics.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}
