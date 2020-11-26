import 'package:flutter/material.dart';
import '../models/trendingItems.dart';
import '../BLoC/music_bloc.dart';

class trendingUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMusic();
    return Scaffold(
      appBar: AppBar(
        title: Text('Trending'),
      ),
      body: StreamBuilder(
        stream: bloc.allMusic,
        builder: (context, AsyncSnapshot<trendingItems> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<trendingItems> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data.results.length,
        itemBuilder: (BuildContext context, int index) {
          return Text(snapshot.data.results[index].album_name);
//          return Image.network(
//            'https://image.tmdb.org/t/p/w185${snapshot.data
//                .results[index].poster_path}',
//            fit: BoxFit.cover,
//          );
        });
  }
}