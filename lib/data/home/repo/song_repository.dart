import 'package:dartz/dartz.dart';
import 'package:flutter_template/domain/home/repo/song_repo.dart';
import 'package:flutter_template/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../domain/home/entity/song_entity.dart';


class SongRepositoryImpl implements SongRepository {
  
  @override
  Future<Either<Exception, List<SongEntity>>> fetchSongs() async {
    try {
      final songs = await getIt<OnAudioQuery>().querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      final songEntities = songs
          .where((song) => song.title.isNotEmpty)
          .map((song) => SongEntity(
                id: song.id,
                title: song.title.trim(),
                artist: (song.artist?.trim() ?? "Unknown Artist"),
              ))
          .toList();

      return Right(songEntities);
    } catch (e) {
      return Left(Exception('Failed to fetch songs: $e'));
    }
  }
}