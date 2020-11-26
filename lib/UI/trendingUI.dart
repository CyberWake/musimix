import 'package:flutter/material.dart';
import 'package:musix/UI/detailsUI.dart';
import '../models/trendingItems.dart';
import '../BLoC/music_bloc.dart';
import '../BLoC/music_detail_bloc_provider.dart';
import 'package:flutter_offline/flutter_offline.dart';

class trendingUI extends StatefulWidget {
  @override
  _trendingUIState createState() => _trendingUIState();
}

class _trendingUIState extends State<trendingUI> {
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
        backgroundColor: Colors.white,
        title: Center(child: Text('Trending',style: TextStyle(color: Colors.black),)),
      ),
      body: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Center(
              child: connected?startListing(): Text(
                'No Internet Connection',
              ),
            );
          },
        child: Container(),
      ),
    );
  }
  Widget startListing(){
    bloc.fetchAllMusic();
    return StreamBuilder(
      stream: bloc.allMusic,
      builder: (context, AsyncSnapshot<trendingItems> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
  Widget buildList(AsyncSnapshot<trendingItems> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) {
          return InkResponse(
            child: Card(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Icon(Icons.library_music, color: Colors.black26,size: 28,),
                    flex: 2,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(snapshot.data.results[index].track_name),
                      subtitle: Text(snapshot.data.results[index].album_name),
                    ),
                    flex: 7,
                  ),
                  Expanded(child: ListTile(
                    trailing: Text(snapshot.data.results[index].artist_name),
                  ),
                  flex: 3,)
//                ListTile(
//                  leading: Icon(Icons.library_music),
//                  title: Text(snapshot.data.results[index].track_name),
//                  subtitle: Text(snapshot.data.results[index].album_name),
//                  trailing: Text(snapshot.data.results[index].artist_name),
//                ),
                ],
              ),
//            child: Text(snapshot.data.results[index].album_name),
            ),
            onTap: () => openDetailPage(snapshot.data, index),
          );
        });
  }
  openDetailPage(trendingItems data, int index) {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MusicDetailBlocProvider(
          child: detailsUI(
              artist_name:data.results[index].artist_name,
              track_name:data.results[index].track_name,
              album_name:data.results[index].album_name,
              explicit:data.results[index].explicit,
              track_rating:data.results[index].track_rating,
              track_id:data.results[index].track_id
          ),
        );
      }),
    );
  }
}
