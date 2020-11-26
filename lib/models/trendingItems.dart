class trendingItems{
  List<_Result> _results = [];
  

  trendingItems.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['message']['body']['track_list'].length);
    List<_Result> temp = [];
    for (int i = 0; i < parsedJson['message']['body']['track_list'].length; i++) {
      _Result result = _Result(parsedJson['message']['body']['track_list'][i]['track']);
      temp.add(result);
    }
    _results = temp;
  }

  List<_Result> get results => _results;
}

class _Result {
  String track_name;
  String track_id;
  String album_name;
  String artist_name;

  _Result(result) {
    this.track_name = result['track_name'];
    this.album_name = result['album_name'];
    this.artist_name = result['artist_name'];
    this.track_id = result['artist_name'];
  }
}