import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../bloc/song_player_cubit.dart';
import '../bloc/song_player_state.dart';
import '../bloc/favorite_cubit.dart';
import '../bloc/playlist_cubit.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final albumArtSize = screenWidth * 0.65;
    final sliderSize = screenWidth * 0.8;
    final borderRadius = albumArtSize / 2;

    // Responsive button sizes
    final smallButtonSize = screenWidth * 0.12; // Approx 55px on a 450px screen
    final mediumButtonSize =
        screenWidth * 0.15; // Approx 65px on a 450px screen
    final largeButtonSize = screenWidth * 0.18; // Approx 80px on a 450px screen

    // Responsive icon sizes
    final smallIconSize = smallButtonSize * 0.55; // Approx 30px
    final mediumIconSize = mediumButtonSize * 0.6; // Approx 40px
    final largeIconSize = largeButtonSize * 0.625; // Approx 50px

    // Responsive AppBar icon sizes
    final appBarButtonSize = screenWidth * 0.1; // Approx 40px on a 450px screen
    final appBarIconSize = appBarButtonSize * 0.6; // Approx 24px

    final leadingAppBarButtonSize =
        screenWidth * 0.08; // Slightly smaller than appBarButtonSize
    final leadingAppBarIconSize =
        leadingAppBarButtonSize * 0.6; // Proportionate icon size

    final actionsAppBarButtonSize =
        screenWidth * 0.08; // Slightly smaller than appBarButtonSize
    final actionsAppBarIconSize =
        actionsAppBarButtonSize * 0.6; // Proportionate icon size

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
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                        toolbarHeight:
                            appBarButtonSize * 1.2, // Make AppBar more compact
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        title: Text(
                          state.song.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis for overflow
                        ),
                      actions: [
                        FutureBuilder<bool>(
                          future: context
                              .read<FavoriteCubit>()
                              .isFavorite(state.song.id.toString()),
                          builder: (context, snapshot) {
                            final isFav = snapshot.data ?? false;
                            return IconButton(
                              iconSize: actionsAppBarIconSize,
                              onPressed: () {
                                if (isFav) {
                                  context
                                      .read<FavoriteCubit>()
                                      .removeFavorite(state.song.id.toString());
                                } else {
                                  context
                                      .read<FavoriteCubit>()
                                      .addFavorite(state.song);
                                }
                              },
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                          // BlocBuilder<PlaylistCubit, PlaylistState>(
                          //   builder: (context, playlistState) {
                          //     if (playlistState is PlaylistLoaded) {
                          //       final playlists = playlistState.playlists;
                          //       return PopupMenuButton<Playlist>(
                          //         icon: Icon(
                          //           Icons.playlist_add,
                          //           color: Colors.white,
                          //         ),
                          //         onSelected: (playlist) {
                          //           context
                          //               .read<PlaylistCubit>()
                          //               .addSongToPlaylist(
                          //                 playlist,
                          //                 state.song,
                          //               );
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //               content: Text(
                          //                 'Added to ${playlist.name}',
                          //               ),
                          //               duration: Duration(seconds: 1),
                          //             ),
                          //           );
                          //         },
                          //         itemBuilder: (context) {
                          //           if (playlists.isEmpty) {
                          //             return [
                          //               const PopupMenuItem(
                          //                 enabled: false,
                          //                 child: Text('No Playlists'),
                          //               ),
                          //             ];
                          //           }
                          //           return playlists
                          //               .map(
                          //                 (playlist) => PopupMenuItem<Playlist>(
                          //                   value: playlist,
                          //                   child: Text(playlist.name),
                          //                 ),
                          //               )
                          //               .toList();
                          //         },
                          //       );
                          //     }
                          //     return const SizedBox.shrink();
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: albumArtSize,
                    height: albumArtSize * 1.5, // Maintain aspect ratio
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
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: QueryArtworkWidget(
                      id: state.song.id,
                      type: ArtworkType.AUDIO,
                      quality: 100,

                      nullArtworkWidget: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(borderRadius),
                            bottomRight: Radius.circular(borderRadius),
                          ),
                        ),
                        child: Icon(
                          Icons.music_note,
                          size: 100,
                          color: Colors.white38,
                        ),
                      ),
                      artworkBorder: BorderRadius.only(
                        bottomLeft: Radius.circular(borderRadius),
                        bottomRight: Radius.circular(borderRadius),
                      ),
                      artworkFit: BoxFit.cover,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      keepOldArtwork: true,

                      artworkQuality: FilterQuality.high,
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
                        size: sliderSize,
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
                    SizedBox(height: screenHeight * 0.08), // Responsive spacing
                    IconTheme(
                      data: IconThemeData(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: smallButtonSize,
                              width: smallButtonSize,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(
                                  smallButtonSize / 2,
                                ),
                              ),
                              child: IconButton(
                                iconSize: smallIconSize,
                                onPressed: () {
                                  context
                                      .read<SongPlayerCubit>()
                                      .toggleShuffle();
                                },
                                icon: Icon(
                                  state.shuffleModeEnabled
                                      ? Icons.shuffle_on
                                      : Icons.shuffle,
                                ),
                              ),
                            ),
                            Container(
                              height: mediumButtonSize,
                              width: mediumButtonSize,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(
                                  mediumButtonSize / 3,
                                ),
                              ),
                              child: IconButton(
                                iconSize: mediumIconSize,
                                onPressed: () {
                                  context
                                      .read<SongPlayerCubit>()
                                      .previousSong();
                                },
                                icon: const Icon(Icons.skip_previous_rounded),
                              ),
                            ),

                            Container(
                              height: largeButtonSize,
                              width: largeButtonSize,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  largeButtonSize / 2,
                                ),
                              ),
                              child: IconButton(
                                iconSize:
                                    largeIconSize, // Adjusted size for prominence
                                onPressed: () {
                                  context
                                      .read<SongPlayerCubit>()
                                      .togglePlayPause();
                                },
                                icon: Icon(
                                  state.isPlaying
                                      ? Icons.pause_circle_filled_rounded
                                      : Icons.play_circle_fill_rounded,
                                ),
                              ),
                            ),

                            Container(
                              height: mediumButtonSize,
                              width: mediumButtonSize,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(
                                  smallButtonSize / 2,
                                ),
                              ),
                              child: IconButton(
                                iconSize: mediumIconSize,
                                onPressed: () {
                                  context.read<SongPlayerCubit>().nextSong();
                                },
                                icon: const Icon(Icons.skip_next_rounded),
                              ),
                            ),
                            Container(
                              height: smallButtonSize,
                              width: smallButtonSize,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(
                                  smallButtonSize / 2,
                                ),
                              ),
                              child: IconButton(
                                iconSize: smallIconSize,
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
                            ),
                          ],
                        ),
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
