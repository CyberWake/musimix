import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musix/UI/bookmarkUI.dart';
import 'package:musix/UI/detailsUI.dart';

import '../BLoC/music_bloc.dart';
import '../BLoC/music_detail_bloc_provider.dart';
import '../models/trendingItems.dart';

class TrendingUI extends StatefulWidget {
  @override
  _TrendingUIState createState() => _TrendingUIState();
}

class _TrendingUIState extends State<TrendingUI> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMusic();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMusic();
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => BookmarkUI()));
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Trending", style: TextStyle(color: Colors.white)),
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
                ? startListing()
                : Text(
                    'No Internet Connection',
                  ),
          );
        },
        child: Container(),
      ),
    );
  }

  Widget startListing() {
    bloc.fetchAllMusic();
    return StreamBuilder(
      stream: bloc.allMusic,
      builder: (context, AsyncSnapshot<TrendingItems> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
            child: SpinKitDualRing(
          color: Colors.blueGrey[900],
        ));
      },
    );
  }

  Widget buildList(AsyncSnapshot<TrendingItems> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.results[index].trackName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data.results[index].albumName,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.results[index].artistName,
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
                  child: DetailsUI(
                      artistName: snapshot.data.results[index].artistName,
                      trackName: snapshot.data.results[index].trackName,
                      albumName: snapshot.data.results[index].albumName,
                      explicit: snapshot.data.results[index].explicit,
                      trackRating: snapshot.data.results[index].trackRating,
                      trackId: snapshot.data.results[index].trackId),
                );
              },
              tappable: true,
            ),
          );
        });
  }
}
