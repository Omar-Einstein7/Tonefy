import 'package:on_audio_query/on_audio_query.dart';

class HomeRepository {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> getSongs() async {
    // get all songs
    var songs = await _audioQuery.querySongs(sortType: SongSortType.DATE_ADDED , orderType: OrderType.DESC_OR_GREATER);

    // remove songs less than 10 seconds long (10,000 milliseconds)
    songs.removeWhere((song) => (song.duration ?? 0) < 10000);

    return songs;
  }
}
