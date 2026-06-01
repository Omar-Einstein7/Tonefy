part of 'playlist_cubit.dart';

abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final List<Playlist> playlists;

  PlaylistLoaded(this.playlists);
}
