import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'playlist_state.dart';

class Playlist {
  final String name;
  final List<SongModel> songs;

  Playlist({required this.name, this.songs = const []});

  Playlist copyWith({String? name, List<SongModel>? songs}) {
    return Playlist(name: name ?? this.name, songs: songs ?? this.songs);
  }
}

class PlaylistCubit extends Cubit<PlaylistState> {
  PlaylistCubit() : super(PlaylistLoaded([]));

  final List<Playlist> _playlists = [];

  void createPlaylist(String name) {
    if (!_playlists.any((p) => p.name == name)) {
      _playlists.add(Playlist(name: name));
      emit(PlaylistLoaded(List.from(_playlists)));
    }
  }

  void addSongToPlaylist(Playlist playlist, SongModel song) {
    final updatedSongs = List<SongModel>.from(playlist.songs)..add(song);
    final updatedPlaylist = playlist.copyWith(songs: updatedSongs);
    final index = _playlists.indexWhere((p) => p.name == playlist.name);
    if (index != -1) {
      _playlists[index] = updatedPlaylist;
      emit(PlaylistLoaded(List.from(_playlists)));
    }
  }

  void removeSongFromPlaylist(Playlist playlist, SongModel song) {
    final updatedSongs = List<SongModel>.from(playlist.songs)
      ..removeWhere((s) => s.id == song.id);
    final updatedPlaylist = playlist.copyWith(songs: updatedSongs);
    final index = _playlists.indexWhere((p) => p.name == playlist.name);
    if (index != -1) {
      _playlists[index] = updatedPlaylist;
      emit(PlaylistLoaded(List.from(_playlists)));
    }
  }

  List<Playlist> get playlists => List.from(_playlists);
}
