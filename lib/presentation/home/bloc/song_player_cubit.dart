import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;

  List<SongModel> _playlist = [];
  int _currentIndex = 0;

  SongPlayerCubit() : super(SongPlayerInitial()) {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      if (state is PlayerState) {
        _updatePlayerState(state.playing);
      }
    });

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      _updateDuration(duration ?? Duration.zero);
    });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      _updatePosition(position);
    });
  }

  void _updatePlayerState(bool isPlaying) {
    if (state is SongPlayerLoaded) {
      emit((state as SongPlayerLoaded).copyWith(isPlaying: isPlaying));
    }
  }

  void _updateDuration(Duration duration) {
    if (state is SongPlayerLoaded) {
      emit((state as SongPlayerLoaded).copyWith(duration: duration));
    }
  }

  void _updatePosition(Duration position) {
    if (state is SongPlayerLoaded) {
      emit((state as SongPlayerLoaded).copyWith(position: position));
    }
  }

  Future<void> loadSong(
    String uri,
    SongModel song, {
    List<SongModel> playlist = const [],
    int index = 0,
  }) async {
    try {
      _playlist = playlist;
      _currentIndex = index;

      await _audioPlayer.stop();
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));

      emit(
        SongPlayerLoaded(
          song: song,
          position: Duration.zero,
          duration: _audioPlayer.duration ?? Duration.zero,
          isPlaying: false,
          shuffleModeEnabled: _audioPlayer.shuffleModeEnabled,
          loopMode: _audioPlayer.loopMode,
        ),
      );

      await _audioPlayer.play();
    } catch (e) {
      emit(SongPlayerError('Failed to load song: e'));
    }
  }

  Future<void> play() async {
    if (state is SongPlayerLoaded) {
      await _audioPlayer.play();
    }
  }

  Future<void> pause() async {
    if (state is SongPlayerLoaded) {
      await _audioPlayer.pause();
    }
  }

  Future<void> togglePlayPause() async {
    if (state is! SongPlayerLoaded) return;

    final currentState = state as SongPlayerLoaded;
    if (currentState.isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> nextSong() async {
    if (_playlist.isEmpty) return;

    if (_audioPlayer.shuffleModeEnabled) {
      _currentIndex = _getRandomIndex();
    } else {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
    }

    final nextSong = _playlist[_currentIndex];
    await loadSong(
      nextSong.uri!,
      nextSong,
      playlist: _playlist,
      index: _currentIndex,
    );
  }

  Future<void> previousSong() async {
    if (_playlist.isEmpty) return;

    if (_audioPlayer.shuffleModeEnabled) {
      _currentIndex = _getRandomIndex();
    } else {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    }

    final previousSong = _playlist[_currentIndex];
    await loadSong(
      previousSong.uri!,
      previousSong,
      playlist: _playlist,
      index: _currentIndex,
    );
  }

  int _getRandomIndex() {
    final random = DateTime.now().millisecondsSinceEpoch % _playlist.length;
    return random;
  }

  Future<void> toggleShuffle() async {
    if (state is! SongPlayerLoaded) return;

    final newShuffleMode = !_audioPlayer.shuffleModeEnabled;
    await _audioPlayer.setShuffleModeEnabled(newShuffleMode);

    final currentState = state as SongPlayerLoaded;
    emit(currentState.copyWith(shuffleModeEnabled: newShuffleMode));
  }

  Future<void> toggleLoop() async {
    if (state is! SongPlayerLoaded) return;

    LoopMode newMode;
    switch (_audioPlayer.loopMode) {
      case LoopMode.off:
        newMode = LoopMode.all;
        break;
      case LoopMode.all:
        newMode = LoopMode.one;
        break;
      case LoopMode.one:
        newMode = LoopMode.off;
        break;
    }

    await _audioPlayer.setLoopMode(newMode);

    final currentState = state as SongPlayerLoaded;
    emit(currentState.copyWith(loopMode: newMode));
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    emit(SongPlayerInitial());
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
