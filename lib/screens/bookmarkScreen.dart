import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:musix/BLoC/music_detail_bloc_provider.dart';
import 'package:musix/models/bookmarks.dart';
import 'package:musix/models/databaseHelper.dart';
import 'package:musix/screens/detailsScreen.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List _bookmarksDB = [];
  List<Bookmark> _bookmarksList = [];
  final _bookmarkDatabase = BookmarkDatabase.instance;
  bool _noBookmarks = false;
  Bookmark bookmark;

  _removeBookmark(int bookmark) {
    if (_bookmarksList.length > 0) {
      setState(() {
        _bookmarksList.removeAt(bookmark);
      });
    }
  }

  void setup() async {
    _bookmarksDB = await _bookmarkDatabase.getAllRows();
    if (_bookmarksDB != null) {
      if (_bookmarksDB.length > 0) {
        _bookmarksDB.forEach((mark) {
          bookmark = Bookmark.fromMapObject(mark);
          _bookmarksList.add(bookmark);
        });
        setState(() {});
      } else {
        setState(() {
          _noBookmarks = true;
        });
      }
    }
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Bookmarked Tracks", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _noBookmarks
            ? Container(
                child: Text('No bookmarked Tracks'),
              )
            : Container(
                child: ListView.builder(
                    itemCount: _bookmarksList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: OpenContainer(
                          transitionDuration: Duration(milliseconds: 400),
                          closedBuilder: (BuildContext c, VoidCallback action) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Icon(
                                      Icons.library_music,
                                      color: Colors.blueGrey[600],
                                      size: 28,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 14,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _bookmarksList[index].trackName,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _bookmarksList[index].albumName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _bookmarksList[index].artistName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          openBuilder: (BuildContext c, VoidCallback action) {
                            return MusicDetailBlocProvider(
                              child: LyricsScreen(
                                artistName: _bookmarksList[index].artistName,
                                trackName: _bookmarksList[index].trackName,
                                albumName: _bookmarksList[index].albumName,
                                explicit: _bookmarksList[index].explicit,
                                trackRating: _bookmarksList[index].trackRating,
                                trackId: _bookmarksList[index].trackId,
                                updateBookmarks: _removeBookmark,
                                index: index,
                              ),
                            );
                          },
                          tappable: true,
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}
