import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

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
  }

  Future<void> _initAudioPlayer() async {
    // Listen to player states
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    // Listen to position changes
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
      appBar: AppBar(
        title: const Text('Now Playing'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art placeholder
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20)
              ),
              child: QueryArtworkWidget(id: widget.song.id, type:ArtworkType.AUDIO ,
              size: 400,
              artworkHeight: 200,
              artworkWidth: 200,
              artworkBorder: BorderRadius.circular(20),),
            ),
            const SizedBox(height: 32),
            // Song title
            Text(
              "${widget.song.title}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Artist name
             Text(
              widget.song.artist!,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            // Progress bar
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _audioPlayer.seek(position);
              },
            ),
            // Duration indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(position.toString().split('.').first),
                  Text(duration.toString().split('.').first),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous button
                IconButton(
                  iconSize: 45,
                  onPressed: () {
                    // Handle previous track
                  },
                  icon: const Icon(Icons.skip_previous_rounded),
                ),
                // Rewind button
                IconButton(
                  iconSize: 45,
                  onPressed: () async {
                    await _audioPlayer.seek(
                      position - const Duration(seconds: 10),
                    );
                  },
                  icon: const Icon(Icons.replay_10_rounded),
                ),
                // Play/Pause button
                IconButton(
                  iconSize: 65,
                  onPressed: () async {
                    if (isPlaying) {
                      await _audioPlayer.pause();
                    } else {
                      await _audioPlayer.play();
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                  ),
                ),
                // Forward button
                IconButton(
                  iconSize: 45,
                  onPressed: () async {
                    await _audioPlayer.seek(
                      position + const Duration(seconds: 10),
                    );
                  },
                  icon: const Icon(Icons.forward_10_rounded),
                ),
                // Next button
                IconButton(
                  iconSize: 45,
                  onPressed: () {
                    // Handle next track
                  },
                  icon: const Icon(Icons.skip_next_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
