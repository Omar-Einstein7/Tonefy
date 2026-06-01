import 'package:Tonefy/presentation/home/bloc/playlist_cubit.dart';
import 'package:Tonefy/presentation/home/bloc/song_player_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:on_audio_query/on_audio_query.dart';

class PlaylistDetailPage extends StatelessWidget {
  final Playlist playlist;

  const PlaylistDetailPage({Key? key, required this.playlist})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(playlist.name)),
      body: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoaded) {
            final currentPlaylist = state.playlists.firstWhere(
              (p) => p.name == playlist.name,
              orElse: () => playlist, // Fallback if playlist not found in state
            );

            if (currentPlaylist.songs.isEmpty) {
              return const Center(
                child: Text('No songs in this playlist yet.'),
              );
            }

            return ListView.builder(
              itemCount: currentPlaylist.songs.length,
              itemBuilder: (context, index) {
                final song = currentPlaylist.songs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(song.title),
                    subtitle: Text(song.artist ?? 'Unknown Artist'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        context.read<PlaylistCubit>().removeSongFromPlaylist(
                          currentPlaylist,
                          song,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Removed ${song.title} from ${currentPlaylist.name}',
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      final currentPlaylistSongs = playlist.songs;
                      final songIndex = currentPlaylistSongs.indexWhere(
                        (s) => s.id == song.id,
                      );
                      context.read<SongPlayerCubit>().loadSong(
                        song.uri!,
                        song,
                        playlist: currentPlaylistSongs,
                        index: songIndex,
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
