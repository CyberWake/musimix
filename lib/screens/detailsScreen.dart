import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musix/models/bookmarks.dart';
import 'package:musix/models/databaseHelper.dart';

import '../BLoC/music_detail_bloc_provider.dart';
import '../models/lyrics.dart';

class LyricsScreen extends StatefulWidget {
  final String artistName;
  final String trackName;
  final String albumName;
  final String explicit;
  final String trackRating;
  final int trackId;
  final Function updateBookmarks;
  final int index;

  LyricsScreen(
      {this.artistName,
      this.trackName,
      this.albumName,
      this.explicit,
      this.trackRating,
      this.trackId,
      this.updateBookmarks,
      this.index});

  @override
  LyricsScreenState createState() => LyricsScreenState();
}

class LyricsScreenState extends State<LyricsScreen> {
  MusicDetailBloc bloc;
  bool isBookmarked = false;
  final _bookmarkDatabase = BookmarkDatabase.instance;
  Bookmark bookmark;
  checkBookmarked() async {
    isBookmarked =
        await _bookmarkDatabase.isAlreadyBookmarked(widget.trackId.toString());
  }

  @override
  void didChangeDependencies() {
    checkBookmarked();
    bloc = MusicDetailBlocProvider.of(context);
    bloc.fetchTrailersById(widget.trackId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget noTrailer(Lyrics data) {
    return Center(
      child: Container(
        child: Text("No trailer available"),
      ),
    );
  }

  Widget trailerLayout(Lyrics data) {
    if (data.results.length > 1) {
      return Row(
        children: <Widget>[
          trailerItem(data, 0),
          trailerItem(data, 1),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          trailerItem(data, 0),
        ],
      );
    }
  }

  trailerItem(Lyrics data, int index) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(data.results[index].lyrics_body, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              isBookmarked = await _bookmarkDatabase
                  .isAlreadyBookmarked(widget.trackId.toString());
              if (isBookmarked) {
                dynamic result = await _bookmarkDatabase
                    .deleteRow(widget.trackId.toString());
                if (result != null) {
                  if (widget.index != null && widget.updateBookmarks != null) {
                    widget.updateBookmarks(widget.index);
                  }
                }
              } else {
                bookmark = Bookmark(
                    albumName: widget.albumName,
                    artistName: widget.artistName,
                    trackId: widget.trackId,
                    trackName: widget.trackName,
                    trackRating: widget.trackRating,
                    explicit: widget.explicit);
                dynamic data = bookmark.toMap();
                dynamic result = await _bookmarkDatabase.addEntry(data);
                if (result != null) {
                  print('');
                }
              }
              isBookmarked = await _bookmarkDatabase
                  .isAlreadyBookmarked(widget.trackId.toString());
              setState(() {});
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Track Details", style: TextStyle(color: Colors.white)),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Center(
              child: connected
                  ? SafeArea(
                      child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${widget.trackName}',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(height: 20),
                                Text(
                                  'Artist',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${widget.artistName}',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(height: 20),
                                Text(
                                  'Album Name',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${widget.albumName}',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(height: 20),
                                Text(
                                  'Explicit',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${widget.explicit}',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(height: 20),
                                Text(
                                  'Rating',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${widget.trackRating}',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(height: 20),
                                Text(
                                  'Lyrics',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 8.0, bottom: 8.0)),
                                StreamBuilder(
                                  stream: bloc.movieTrailers,
                                  builder: (context,
                                      AsyncSnapshot<Future<Lyrics>> snapshot) {
                                    if (snapshot.hasData) {
                                      return FutureBuilder(
                                        future: snapshot.data,
                                        builder: (context,
                                            AsyncSnapshot<Lyrics>
                                                itemSnapShot) {
                                          if (itemSnapShot.hasData) {
                                            if (itemSnapShot
                                                    .data.results.length >
                                                0)
                                              return trailerLayout(
                                                  itemSnapShot.data);
                                            else
                                              return noTrailer(
                                                  itemSnapShot.data);
                                          } else {
                                            return Center(
                                                child: SpinKitDualRing(
                                              color: Colors.blueGrey[900],
                                            ));
                                          }
                                        },
                                      );
                                    } else {
                                      return Center(
                                          child: SpinKitDualRing(
                                        color: Colors.blueGrey[900],
                                      ));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 250,
                            width: 250,
                            child: Image.asset('assets/no_internet.gif')),
                        Text(
                          'Connect to network!',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )
                      ],
                    ));
        },
        child: Container(),
      ),
    );
  }
}
