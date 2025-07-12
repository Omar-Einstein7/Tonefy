import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SongPage extends StatefulWidget {
  final SongModel song;
  const SongPage({super.key, required this.song});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _setAudioSource();
  }

  Future<void> _setAudioSource() async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(widget.song.uri!)),
      );
    } catch (e) {
      // Handle error loading audio source
      print("Error loading audio source: \$e");
    }
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    _audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    _audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                AppBar(
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
                    id: widget.song.id,
                    type: ArtworkType.AUDIO,
                    size: 400,
                    artworkHeight: 200,
                    artworkWidth: 400,
                    artworkBorder: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SleekCircularSlider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    initialValue: position.inSeconds.toDouble().clamp(
                      0,
                      duration.inSeconds.toDouble(),
                    ),

                    onChange: (value) async {
                      final newPosition = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(newPosition);
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
                        trackColor: Colors.black12,
                        progressBarColor: Colors.black,
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
                    widget.song.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.song.artist ?? "Unknown Artist",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Now Playing'),
    //     centerTitle: true,
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Container(
    //           decoration: BoxDecoration(
    //             border: Border.all(),
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: QueryArtworkWidget(
    //             id: widget.song.id,
    //             type: ArtworkType.AUDIO,
    //             size: 400,
    //             artworkHeight: 200,
    //             artworkWidth: 200,
    //             artworkBorder: BorderRadius.circular(20),
    //           ),
    //         ),
    //         const SizedBox(height: 32),
    //         Text(
    //           widget.song.title,
    //           style: const TextStyle(
    //             fontSize: 24,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         const SizedBox(height: 4),
    //         Text(
    //           widget.song.artist ?? "Unknown Artist",
    //           style: const TextStyle(fontSize: 18),
    //         ),
    //         const SizedBox(height: 24),
    //         Slider(
    //           min: 0,
    //           max: duration.inSeconds.toDouble(),
    //           value: position.inSeconds.toDouble().clamp(0, duration.inSeconds.toDouble()),
    //           onChanged: (value) async {
    //             final newPosition = Duration(seconds: value.toInt());
    //             await _audioPlayer.seek(newPosition);
    //           },
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text(position.toString().split('.').first),
    //               Text(duration.toString().split('.').first),
    //             ],
    //           ),
    //         ),
    //         const SizedBox(height: 24),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             IconButton(
    //               iconSize: 45,
    //               onPressed: () {
    //                 // TODO: Implement previous track functionality
    //               },
    //               icon: const Icon(Icons.skip_previous_rounded),
    //             ),
    //             // IconButton(
    //             //   iconSize: 45,
    //             //   onPressed: () async {
    //             //     final newPosition = position - const Duration(seconds: 10);
    //             //     await _audioPlayer.seek(newPosition >= Duration.zero ? newPosition : Duration.zero);
    //             //   },
    //             //   icon: const Icon(Icons.replay_10_rounded),
    //             // ),
    //             IconButton(
    //               iconSize: 65,
    //               onPressed: () async {
    //                 if (isPlaying) {
    //                   await _audioPlayer.pause();
    //                 } else {
    //                   await _audioPlayer.play();
    //                 }
    //               },
    //               icon: Icon(
    //                 isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
    //               ),
    //             ),
    //             // IconButton(
    //             //   iconSize: 45,
    //             //   onPressed: () async {
    //             //     final newPosition = position + const Duration(seconds: 10);
    //             //     await _audioPlayer.seek(newPosition <= duration ? newPosition : duration);
    //             //   },
    //             //   icon: const Icon(Icons.forward_10_rounded),
    //             // ),
    //             IconButton(
    //               iconSize: 45,
    //               onPressed: () {
    //                 // TODO: Implement next track functionality
    //               },
    //               icon: const Icon(Icons.skip_next_rounded),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(height: 24),
    //         IconButton(
    //           iconSize: 40,
    //           onPressed: () {
    //             // TODO: Implement favorite functionality
    //           },
    //           icon: const Icon(Icons.favorite_border),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
