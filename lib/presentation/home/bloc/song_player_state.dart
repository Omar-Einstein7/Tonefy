import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class SongPlayerState {
  const SongPlayerState();
}

class SongPlayerInitial extends SongPlayerState {
  const SongPlayerInitial();
}

class SongPlayerLoading extends SongPlayerState {
  const SongPlayerLoading();
}

class SongPlayerLoaded extends SongPlayerState {
  final SongModel song;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool shuffleModeEnabled;
  final LoopMode loopMode;

  const SongPlayerLoaded({
    required this.song,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.shuffleModeEnabled,
    required this.loopMode,
  });

  SongPlayerLoaded copyWith({
    SongModel? song,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? shuffleModeEnabled,
    LoopMode? loopMode,
  }) {
    return SongPlayerLoaded(
      song: song ?? this.song,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      shuffleModeEnabled: shuffleModeEnabled ?? this.shuffleModeEnabled,
      loopMode: loopMode ?? this.loopMode,
    );
  }
}

class SongPlayerError extends SongPlayerState {
  final String message;

  const SongPlayerError(this.message);
}