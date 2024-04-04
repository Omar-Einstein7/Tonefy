import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tonefy/bloc/Songbloc/song_bloc.dart';
import 'package:tonefy/bloc/Songbloc/song_state.dart';
import 'package:tonefy/presentation/widgets/fav_song_list_tile.dart';
import 'package:tonefy/presentation/widgets/song_list_tile.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purpleAccent, Colors.blue])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
          backgroundColor: Colors.transparent,
          title: Text("Favourits"),
          centerTitle: true,
        ),
        body: Expanded(
            child: BlocBuilder<SongBloc, SongState>(builder: (context, state) {
          if (state.Songitems.isEmpty) {
            return Center(
              child: Text("EMPTY"),
            );
          } else {
            return ListView.builder(
                itemCount: state.Songitems.length,
                itemBuilder: (_, i) {
                  var data = state.Songitems[i];
                  return FavSongListTile(song: data);
                });
          }
        })),
      ),
    );
  }
}
