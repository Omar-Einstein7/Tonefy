import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tonefy/presentation/home/bloc/favorite_cubit.dart';
import 'package:Tonefy/presentation/home/bloc/home_cubit.dart';
import 'package:Tonefy/presentation/home/widget/song_card.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, favoriteState) {
          if (favoriteState is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (favoriteState is FavoriteLoaded) {
            if (favoriteState.favorites.isEmpty) {
              return const Center(child: Text('No favorite songs yet.'));
            }
            return BlocBuilder<HomeCubit, HomeState>(
              builder: (context, homeState) {
                if (homeState is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (homeState is HomeLoaded) {
                  final favorites = favoriteState.favorites;
                  final allSongs = homeState.songs;

                  final favoriteSongs = allSongs.where((song) {
                    return favorites.any((fav) => fav.id == song.id.toString());
                  }).toList();

                  if (favoriteSongs.isEmpty && favorites.isNotEmpty) {
                    return const Center(
                      child: Text('Favorite songs not found on device.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: favoriteSongs.length,
                    itemBuilder: (context, index) {
                      final song = favoriteSongs[index];
                      return SongCard(
                        song: song,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<FavoriteCubit>().removeFavorite(
                              song.id.toString(),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Could not load songs.'));
                }
              },
            );
          } else if (favoriteState is FavoriteError) {
            return Center(child: Text(favoriteState.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
