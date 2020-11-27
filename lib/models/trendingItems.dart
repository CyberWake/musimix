class TrendingItems {
  List<_Result> _results = [];

  TrendingItems.fromJson(Map<String, dynamic> parsedJson) {
    List<_Result> temp = [];
    for (int i = 0;
        i < parsedJson['message']['body']['track_list'].length;
        i++) {
      _Result result =
          _Result(parsedJson['message']['body']['track_list'][i]['track']);
      temp.add(result);
    }
    _results = temp;
  }

  List<_Result> get results => _results;
}

class _Result {
  String trackName;
  int trackId;
  String albumName;
  String artistName;
  String explicit;
  String trackRating;

  _Result(result) {
    this.trackName = result['track_name'];
    this.albumName = result['album_name'];
    this.artistName = result['artist_name'];
    this.trackId = result['track_id'];
    this.explicit = result['explicit'] == 1 ? 'True' : 'False';
    this.trackRating = result['track_rating'].toString();
  }
}
