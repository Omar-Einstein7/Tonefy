import 'package:Tonefy/domain/home/repo/song_repo.dart';
import 'package:Tonefy/service_locator.dart';
import 'package:dartz/dartz.dart';

import 'package:on_audio_query/on_audio_query.dart';


class SongRepositoryImpl implements SongRepository {
  @override
  Future<Either<Exception, List<SongModel>>> fetchSongs() async {
    try {
      final songs = await getIt<OnAudioQuery>().querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      final filteredSongs = songs.where((song) => song.title.isNotEmpty).toList();

      return Right(filteredSongs);
    } catch (e) {
      return Left(Exception('Failed to fetch songs: $e'));
    }
  }
}