import 'package:Tonefy/presentation/home/widget/songe_card.dart';
import 'package:Tonefy/presentation/home/widget/mini_player_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_cubit.dart';
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
            appBar: AppBar(
              title: Text(
                'Songs',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white.withOpacity(0.2),
              elevation: 0,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.white.withOpacity(0.1)),
                ),
              ),
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeCubit>().fetchSongs();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 86.0,
                      ), // Add padding for the mini-player
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return SongeCard(
                          id: song.id,
                          title: song.title,
                          artist: song.artist!,
                          songModel: song,
                        );
                      },
                    ),
                  );
                } else if (state is HomeError) {
                  return Center(child: Text('Error: \${state.message}'));
                } else {
                  return const SizedBox.shrink();
                }
              },
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
}
