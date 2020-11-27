import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musix/screens/bookmarkScreen.dart';
import 'package:musix/screens/detailsScreen.dart';

import '../BLoC/music_bloc.dart';
import '../BLoC/music_detail_bloc_provider.dart';
import '../models/trendingItems.dart';

class TrendingScreen extends StatefulWidget {
  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  @override
  void initState() {
    super.initState();
    bloc.fetchMusicData();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchMusicData();
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Container(
            width: 40,
            child: OpenContainer(
              transitionDuration: Duration(milliseconds: 400),
              closedColor: Colors.blueGrey[900],
              tappable: true,
              closedElevation: 0.0,
              openElevation: 0.0,
              closedBuilder: (BuildContext c, VoidCallback action) {
                return Icon(
                  Icons.bookmark,
                  color: Colors.white,
                );
              },
              openBuilder: (BuildContext c, VoidCallback action) {
                return BookmarkScreen();
              },
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Trending", style: TextStyle(color: Colors.white)),
      ),
      body: OfflineBuilder(
        child: Container(),
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          return Center(
              child: connected
                  ? startListing()
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
      ),
    );
  }

  Widget startListing() {
    bloc.fetchMusicData();
    return StreamBuilder(
      stream: bloc.allMusic,
      builder: (context, AsyncSnapshot<TrendingItems> snapshot) {
        if (snapshot.hasData) {
          return buildMusicList(snapshot);
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

  Widget buildMusicList(AsyncSnapshot<TrendingItems> snapshot) {
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
                  child: LyricsScreen(
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
