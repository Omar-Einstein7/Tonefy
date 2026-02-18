import 'package:Tonefy/presentation/home/page/song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../common/navigation/app_navigations.dart';
import '../bloc/home_cubit.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';

class SongeCard extends StatelessWidget {
  final SongModel songModel;
  final int id;
  final String title;
  final String artist;

  const SongeCard({
    super.key,
    required this.id,
    required this.title,
    required this.artist,
    required this.songModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final homeState = context.read<HomeCubit>().state;
        List<SongModel> playlist = [];
        int index = 0;

        if (homeState is HomeLoaded) {
          playlist = homeState.songs;
          index = playlist.indexWhere((element) => element.id == songModel.id);
        }

        final playerState = context.read<SongPlayerCubit>().state;
        bool isSameSong = false;

        if (playerState is SongPlayerLoaded &&
            playerState.song.id == songModel.id) {
          isSameSong = true;
        }

        if (!isSameSong) {
          context.read<SongPlayerCubit>().loadSong(
            songModel.uri!,
            songModel,
            playlist: playlist,
            index: index,
          );
        }

        AppNavigator.push(context, const SongPage());
      },
      child: Card(
        color: Colors.white.withOpacity(0.4),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.6), width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 50,
                height: 50,
                child: QueryArtworkWidget(
                  id: id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              artist,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.play_arrow_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
