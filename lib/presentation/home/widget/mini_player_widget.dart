import 'package:Tonefy/presentation/home/bloc/song_player_cubit.dart';
import 'package:Tonefy/presentation/home/bloc/song_player_state.dart';
import 'package:Tonefy/presentation/home/page/song_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:on_audio_query/on_audio_query.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoaded) {
          return GestureDetector(
            onTap: () {
              // Navigate to the full song page
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SongPage(),
              ));
            },
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                   child:  QueryArtworkWidget(
                      id: state.song.id,
                      type: ArtworkType.AUDIO,
                   
                    
                      artworkFit: BoxFit.cover,
                      artworkQuality: FilterQuality.high,
                      keepOldArtwork: true,
                      quality: 100,
                    ),
                  ),
                 
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.song.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          state.song.artist ?? 'Unknown Artist',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.black54),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      state.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Theme.of(context).colorScheme.primary,
                      size: 36,
                    ),
                    onPressed: () {
                      if (state.isPlaying) {
                        context.read<SongPlayerCubit>().pause();
                      } else {
                        context.read<SongPlayerCubit>().play();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: Theme.of(context).colorScheme.primary,
                      size: 36,
                    ),
                    onPressed: () {
                      context.read<SongPlayerCubit>().nextSong();
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
