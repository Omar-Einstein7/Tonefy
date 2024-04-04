import 'package:animated_overflow/animated_overflow.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tonefy/data/repo/song_repository.dart';
import 'package:tonefy/utils/extensions.dart';

class PlayerPage extends StatefulWidget {
  final MediaItem mediaItem;
  const PlayerPage({
    Key? key,
    required this.mediaItem,
  }) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final SongRepository songRepository;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  Future<void> initPlayer() async {
    songRepository = context.read<SongRepository>();

    songRepository.mediaItem.listen((mediaItem) async {
      if (mediaItem != null) {
        // if media item is same skip
        if (mediaItem.id != widget.mediaItem.id) {
          try {
            int index = songRepository.getMediaItemIndex(widget.mediaItem);
            await songRepository.playFromQueue(index);
          } catch (_) {}
        }

        if (mounted) {
          setState(() {
            _duration = mediaItem.duration ?? Duration.zero;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(101, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.white,
              )),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          StreamBuilder<MediaItem?>(
              stream: songRepository.mediaItem,
              builder: (context, snapshot) {
                final mediaItem = snapshot.data;
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Blur(
                      blur: 5,
                      blurColor: Theme.of(context).primaryColor,
                      child: QueryArtworkWidget(
                          artworkFit: BoxFit.cover,
                          artworkWidth: MediaQuery.of(context).size.width,
                          artworkHeight: MediaQuery.of(context).size.height,
                          id: int.parse(mediaItem?.id ?? '0'),
                          keepOldArtwork: true,
                          nullArtworkWidget: Icon(
                            Icons.music_note,
                            size: double.infinity,
                          ),
                          type: ArtworkType.AUDIO)),
                );
              }),
          Container(
            padding: EdgeInsets.only(top: height * 0.15),
            child: Stack(
              children: [
                StreamBuilder<MediaItem?>(
                    stream: songRepository.mediaItem,
                    builder: (_, snapshot) {
                      final mediaItem = snapshot.data;
                      return Column(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                width: width,
                                // color: Colors.yellow,
                                child: Stack(
                                  alignment: AlignmentDirectional.topCenter,
                                  children: [
                                    Container(
                                        width: width * 0.6,
                                        height: height * 0.37,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(width * 0.3),
                                              bottomRight:
                                                  Radius.circular(width * 0.3),
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(40)),
                                        ),
                                        child: QueryArtworkWidget(
                                          id: int.parse(mediaItem?.id ?? '0'),
                                          type: ArtworkType.AUDIO,
                                          artworkQuality: FilterQuality.high,
                                          quality: 100,
                                          nullArtworkWidget: Container(
                                              width: 50,
                                              height: 50,
                                              child: Icon(
                                                Icons.music_note,
                                                size: 100,
                                              )),
                                          artworkBorder: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(width * 0.3),
                                              bottomRight:
                                                  Radius.circular(width * 0.3),
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40)),
                                          artworkWidth: double.infinity,
                                          artworkHeight: width - 64,
                                          artworkFit: BoxFit.fill,
                                        )),
                                    Align(
                                      alignment: Alignment.center,
                                      child: StreamBuilder<Duration>(
                                          stream: songRepository.position,
                                          builder: (context, snapshot) {
                                            final position =
                                                snapshot.data ?? Duration.zero;
                                            try {
                                              return Align(
                                                alignment: Alignment(0, -0.3),
                                                child: SleekCircularSlider(
                                                  appearance:
                                                      CircularSliderAppearance(
                                                          size: width * 0.7,
                                                          angleRange: 140,
                                                          startAngle: 160,
                                                          counterClockwise:
                                                              true,
                                                          customWidths:
                                                              CustomSliderWidths(
                                                            trackWidth: 3,
                                                            progressBarWidth: 5,
                                                            shadowWidth: 5,
                                                            handlerSize: 7,
                                                          ),
                                                          infoProperties: InfoProperties(
                                                              mainLabelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .transparent)),
                                                          customColors:
                                                              CustomSliderColors(
                                                                  trackColor:
                                                                      Colors
                                                                          .black,
                                                                  progressBarColor:
                                                                      Colors
                                                                          .black,
                                                                  dotColor: Colors
                                                                      .black)),
                                                  min: 0,
                                                  max: _duration?.inMilliseconds
                                                          .toDouble() ??
                                                      0,
                                                  initialValue: position
                                                      .inMilliseconds
                                                      .toDouble(),
                                                  onChange: (value) {
                                                    songRepository.seek(
                                                        Duration(
                                                            milliseconds:
                                                                value.toInt()));
                                                  },
                                                ),
                                              );
                                            } catch (e) {
                                              return SleekCircularSlider(
                                                appearance:
                                                    CircularSliderAppearance(
                                                        size: width * 0.7,
                                                        angleRange: 140,
                                                        startAngle: 160,
                                                        counterClockwise: true,
                                                        customWidths:
                                                            CustomSliderWidths(
                                                          trackWidth: 3,
                                                          progressBarWidth: 5,
                                                          shadowWidth: 5,
                                                          handlerSize: 7,
                                                        ),
                                                        infoProperties: InfoProperties(
                                                            mainLabelStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .transparent)),
                                                        customColors:
                                                            CustomSliderColors(
                                                                trackColor:
                                                                    Colors
                                                                        .black,
                                                                progressBarColor:
                                                                    Colors
                                                                        .black,
                                                                dotColor: Colors
                                                                    .black)),
                                                min: 0,
                                                max: 0,
                                                initialValue: 0,
                                                // onChange: (value) {
                                                //   songRepository.seek(Duration(
                                                //       milliseconds: value.toInt()));
                                                // },
                                              );
                                            }
                                          }),
                                    ),
                                    Positioned(
                                      height: height * 0.12,
                                      bottom: 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          StreamBuilder<Duration>(
                                              stream: songRepository.position,
                                              builder: (context, snapshot) {
                                                final position =
                                                    snapshot.data ??
                                                        Duration.zero;
                                                return Text(
                                                  position.toHms(),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              }),
                                          SizedBox(
                                            width: width * 0.7,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: AutoScrollText(
                                                mediaItem?.title ?? 'Unknown',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                mode:
                                                    AutoScrollTextMode.endless,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            mediaItem?.artist == null
                                                ? "unknown"
                                                : "${mediaItem!.artist}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            // color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StreamBuilder<bool>(
                                  stream: songRepository.shuffleModeEnabled,
                                  builder: (context, snapshot) {
                                    return IconButton(
                                      onPressed: () async {
                                        await songRepository
                                            .setShuffleModeEnabled(
                                          !(snapshot.data ?? false),
                                        );
                                      },
                                      icon: snapshot.data == false
                                          ? const Icon(
                                              Icons.shuffle_rounded,
                                              color: Colors.grey,
                                            )
                                          : const Icon(Icons.shuffle_rounded),
                                      iconSize: 30,
                                    );
                                  },
                                ),
                                Container(
                                  width: width * 0.6,
                                  height: height * 0.15,
                                  // color: Colors.greenAccent,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: width * 0.6,
                                          height: height * 0.07,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    songRepository
                                                        .seekPrevious();
                                                  },
                                                  icon: Icon(Icons
                                                      .arrow_back_ios_new)),
                                              IconButton(
                                                  onPressed: () {
                                                    songRepository.seekNext();
                                                  },
                                                  icon: Icon(
                                                      Icons.arrow_forward_ios)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 2)
                                              // color: Colors.blueAccent,
                                              ),
                                          child: //                         // play/pause button
                                              StreamBuilder<bool>(
                                            stream: songRepository.playing,
                                            builder: (context, snapshot) {
                                              final playing =
                                                  snapshot.data ?? false;
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    if (playing) {
                                                      await songRepository
                                                          .pause();
                                                    } else {
                                                      await songRepository
                                                          .play();
                                                    }
                                                  },
                                                  icon: playing
                                                      ? const Icon(
                                                          Icons.pause_rounded,
                                                          color: Colors.black,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          color: Colors.black),
                                                  iconSize: 40,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                StreamBuilder<LoopMode>(
                                    stream: songRepository.loopMode,
                                    builder: (context, snapshot) {
                                      return IconButton(
                                        onPressed: () async {
                                          if (snapshot.data == LoopMode.off) {
                                            await songRepository
                                                .setLoopMode(LoopMode.all);
                                          } else if (snapshot.data ==
                                              LoopMode.all) {
                                            await songRepository
                                                .setLoopMode(LoopMode.one);
                                          } else {
                                            await songRepository
                                                .setLoopMode(LoopMode.off);
                                          }
                                        },
                                        icon: snapshot.data == LoopMode.off
                                            ? const Icon(
                                                Icons.repeat_rounded,
                                                color: Colors.grey,
                                              )
                                            : snapshot.data == LoopMode.all
                                                ? const Icon(
                                                    Icons.repeat_rounded)
                                                : const Icon(
                                                    Icons.repeat_one_rounded),
                                        iconSize: 30,
                                      );
                                    }),
                              ],
                            ),
                          )),
                        ],
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
