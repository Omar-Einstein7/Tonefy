import 'package:Tonefy/presentation/home/widget/songe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../bloc/home_cubit.dart';
import '../../../service_locator.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..fetchSongs(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Songs'),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              final songs = state.songs;
              if (songs.isEmpty) {
                return const Center(child: Text('No Songs Found'));
              }
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return SongeCard(id: song.id, title: song.title, artist: song.artist! ,songModel: song,);
                },
              );
            } else if (state is HomeError) {
              return Center(child: Text('Error: \${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}