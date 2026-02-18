import 'package:Tonefy/common/navigation/app_navigations.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';
import '../widget/loading_animation_widget.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SongPlayerCubit, SongPlayerState>(
        builder: (context, state) {
          if (state is SongPlayerLoaded) {
            return _buildPlayerUI(context, state);
          } else if (state is SongPlayerLoading) {
            return const LoadingAnimationWidget(message: 'Loading song...');
          } else if (state is SongPlayerError) {
            return LoadingAnimationWidget(message: 'Error: ${state.message}');
          } else {
            return const LoadingAnimationWidget(
              message:
                  'No song selected. Please select a song from the home screen.',
            );
          }
        },
      ),
    );
  }

  Widget _buildPlayerUI(BuildContext context, SongPlayerLoaded state) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: QueryArtworkWidget(
            id: state.song.id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: Container(
              color: Colors.black,
              child: Icon(Icons.music_note, size: 200, color: Colors.white12),
            ),
            artworkFit: BoxFit.cover,
            artworkHeight: double.infinity,
            artworkWidth: double.infinity,
            quality: 100,
            keepOldArtwork: true,
          ),
        ),
        // Blur Effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
        ),
        // Content
        Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.short_text_outlined),
                      ),
                    ],
                  ),
                  Container(
                    width: 220,
                    height: 380,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0, 20),
                          blurRadius: 30,
                          spreadRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200),
                      ),
                    ),
                    child: QueryArtworkWidget(
                      id: state.song.id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                            bottomRight: Radius.circular(200),
                          ),
                        ),
                        child: Icon(
                          Icons.music_note,
                          size: 100,
                          color: Colors.white38,
                        ),
                      ),
                      artworkBorder: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200),
                      ),
                      artworkFit: BoxFit.cover,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      keepOldArtwork: true,
                      quality: 100,
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SleekCircularSlider(
                      min: 0,
                      max: state.duration.inSeconds.toDouble(),
                      initialValue: state.position.inSeconds.toDouble().clamp(
                        0,
                        state.duration.inSeconds.toDouble(),
                      ),
                      onChangeEnd: (value) async {
                        final newPosition = Duration(seconds: value.toInt());
                        context.read<SongPlayerCubit>().seek(newPosition);
                      },
                      appearance: CircularSliderAppearance(
                        size: 360,
                        counterClockwise: true,
                        startAngle: 150,
                        angleRange: 120,
                        customWidths: CustomSliderWidths(
                          trackWidth: 3,
                          progressBarWidth: 10,
                          shadowWidth: 0,
                        ),
                        customColors: CustomSliderColors(
                          trackColor: Colors.white24,
                          progressBarColor: Colors.white,
                        ),
                        infoProperties: InfoProperties(
                          mainLabelStyle: TextStyle(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      state.song.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      state.song.artist ?? "Unknown Artist",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 90),
                    IconTheme(
                      data: IconThemeData(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 35,
                            onPressed: () {
                              context.read<SongPlayerCubit>().toggleShuffle();
                            },
                            icon: Icon(
                              state.shuffleModeEnabled
                                  ? Icons.shuffle_on
                                  : Icons.shuffle,
                            ),
                          ),
                          IconButton(
                            iconSize: 45,
                            onPressed: () {
                              context.read<SongPlayerCubit>().playPrevious();
                            },
                            icon: const Icon(Icons.skip_previous_rounded),
                          ),

                          IconButton(
                            iconSize: 65,
                            onPressed: () {
                              context.read<SongPlayerCubit>().playPause();
                            },
                            icon: Icon(
                              state.isPlaying
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_fill_rounded,
                            ),
                          ),

                          IconButton(
                            iconSize: 45,
                            onPressed: () {
                              context.read<SongPlayerCubit>().playNext();
                            },
                            icon: const Icon(Icons.skip_next_rounded),
                          ),
                          IconButton(
                            iconSize: 35,
                            onPressed: () {
                              context.read<SongPlayerCubit>().toggleLoop();
                            },
                            icon: Icon(
                              state.loopMode == LoopMode.one
                                  ? Icons.repeat_one_rounded
                                  : (state.loopMode == LoopMode.all
                                        ? Icons.repeat_rounded
                                        : Icons.repeat_rounded),
                              color: state.loopMode == LoopMode.off
                                  ? Colors.white54
                                  : Colors.purpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
