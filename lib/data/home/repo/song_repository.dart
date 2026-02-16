import 'package:Tonefy/domain/home/repo/song_repo.dart';
import 'package:Tonefy/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';


class SongRepositoryImpl implements SongRepository {
  @override
  Future<Either<Exception, List<SongModel>>> fetchSongs() async {
    try {
      // Request permissions first to avoid plugin crash
      bool permissionGranted = false;
      
      // Check/Request Storage permission (Android 12 and below)
      var storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        storageStatus = await Permission.storage.request();
      }
      
      if (storageStatus.isGranted) {
        permissionGranted = true;
      } else {
        // Check/Request Audio permission (Android 13+)
        var audioStatus = await Permission.audio.status;
        if (!audioStatus.isGranted) {
          audioStatus = await Permission.audio.request();
        }
        if (audioStatus.isGranted) {
          permissionGranted = true;
        }
      }

      if (!permissionGranted) {
         return Left(Exception('Permission denied'));
      }

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