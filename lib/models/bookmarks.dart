class Bookmark {
  String artistName;
  String trackName;
  String albumName;
  String explicit;
  String trackRating;
  int trackId;
  Bookmark(
      {this.artistName,
      this.trackName,
      this.albumName,
      this.explicit,
      this.trackRating,
      this.trackId});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['artistName'] = artistName;
    map['trackName'] = trackName;
    map['albumName'] = albumName;
    map['explicit'] = explicit;
    map['trackRating'] = artistName;
    map['trackId'] = trackId;
    return map;
  }

  Bookmark.fromMapObject(Map<String, dynamic> map) {
    this.artistName = map['artistName'];
    this.trackName = map['trackName'];
    this.albumName = map['albumName'];
    this.explicit = map['explicit'];
    this.trackRating = map['trackRating'];
    this.trackId = map['trackId'];
  }
}
