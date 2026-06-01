// import 'package:Tonefy/presentation/home/bloc/song_player_cubit.dart';
// import 'package:Tonefy/presentation/home/bloc/song_player_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// part 'recent_state.dart';

// class RecentCubit extends Cubit<RecentState> {
//   final SongPlayerCubit _songPlayerCubit;
//   final List<SongModel> _recentSongs = [];

//   RecentCubit(this._songPlayerCubit) : super(RecentInitial()) {
//     _songPlayerCubit.stream.listen((songPlayerState) {
//       if (songPlayerState is SongPlayerLoaded &&
//           songPlayerState.processingState == ProcessingState.completed) {
//         _addSongToRecent(songPlayerState.song);
//       }
//     });
//   }

//   void _addSongToRecent(SongModel song) {
//     // Remove if already exists to move it to the top
//     _recentSongs.removeWhere((s) => s.id == song.id);
//     _recentSongs.insert(0, song); // Add to the beginning
//     // Limit to a certain number of recent songs, e.g., 20
//     if (_recentSongs.length > 20) {
//       _recentSongs.removeLast();
//     }
//     emit(RecentLoaded(List.from(_recentSongs)));
//   }

//   List<SongModel> get recentSongs => List.from(_recentSongs);
// }
