import 'package:Tonefy/presentation/home/page/favorite_page.dart';
import 'package:Tonefy/presentation/home/page/playlist_detail_page.dart';
import 'package:Tonefy/presentation/home/widget/song_card.dart';
import 'package:Tonefy/presentation/home/widget/mini_player_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../bloc/home_cubit.dart';
import '../bloc/favorite_cubit.dart';

import '../bloc/playlist_cubit.dart';

import '../bloc/recent_cubit.dart';

import '../../../service_locator.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..fetchSongs(),
      child: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0C3FC), // Soft Purple
                  Color(0xFF8EC5FC), // Soft Blue
                ],
              ),
            ),
          ),

          // Glass Content
          Scaffold(
            backgroundColor: Colors.transparent,
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeCubit>().fetchSongs();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: const Text(
                      'Songs',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    elevation: 0,
                    expandedHeight:
                        200.0, // Adjust height to accommodate containers
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            color: Colors.white.withOpacity(0.1),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 80.0,
                                left: 16.0,
                                right: 16.0,
                              ), // Adjust top padding to clear title
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSectionContainer(context, 'Favourite'),
                                  _buildSectionContainer(context, 'Playlist'),
                                  _buildSectionContainer(context, 'Recent'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    pinned: true, // Keeps the app bar visible at the top
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is HomeLoaded) {
                        final songs = state.songs;
                        if (songs.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(child: Text('No Songs Found')),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final song = songs[index];
                            return SongCard(song: song);
                          }, childCount: songs.length),
                        );
                      } else if (state is HomeError) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text('Error: \${state.message}'),
                          ),
                        );
                      } else {
                        return const SliverFillRemaining(
                          child: SizedBox.shrink(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // Mini Player
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayerWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(BuildContext context, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth =
        (screenWidth - 32 - 16) /
        3; // Total padding 32 (16*2), spacing 16 (8*2)

    return InkWell(
      onTap: () {
        Widget targetPage;
        switch (title) {
          case 'Favourite':
            targetPage = FavoritePage();
            break;
          case 'Playlist':
            targetPage = PlaylistPage();
            break;
          case 'Recent':
            targetPage = PlaylistPage();
            break;
          default:
            targetPage = const Text('Unknown Page'); // Fallback
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: containerWidth,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Songs')),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoaded) {
            final favoriteSongs = state.favorites;
            if (favoriteSongs.isEmpty) {
              return const Center(child: Text('No Favourite Songs Yet!'));
            }
            return ListView.builder(
              itemCount: favoriteSongs.length,
              itemBuilder: (context, index) {
                final song = favoriteSongs[index];
                return SongCard(song: song);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PlaylistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlists')),
      body: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoaded) {
            final playlists = state.playlists;
            if (playlists.isEmpty) {
              return const Center(
                child: Text('No Playlists Yet! Create one below.'),
              );
            }
            return ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(playlist.name),
                    subtitle: Text('${playlist.songs.length} songs'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PlaylistDetailPage(playlist: playlist),
                        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePlaylistDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    TextEditingController _playlistNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Create New Playlist'),
          content: TextField(
            controller: _playlistNameController,
            decoration: const InputDecoration(hintText: 'Playlist Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                if (_playlistNameController.text.isNotEmpty) {
                  context.read<PlaylistCubit>().createPlaylist(
                    _playlistNameController.text,
                  );
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

// class RecentPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Recently Played')),
//       body: BlocBuilder<RecentCubit, RecentState>(
//         builder: (context, state) {
//           if (state is RecentLoaded) {
//             final recentSongs = state.recentSongs;
//             if (recentSongs.isEmpty) {
//               return const Center(child: Text('No Recently Played Songs Yet!'));
//             }
//             return ListView.builder(
//               itemCount: recentSongs.length,
//               itemBuilder: (context, index) {
//                 final song = recentSongs[index];
//                 return SongCard(
//                   id: song.id,
//                   title: song.title,
//                   artist: song.artist!,
//                   songModel: song,
//                 );
//               },
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
