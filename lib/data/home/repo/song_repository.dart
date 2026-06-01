import 'package:Tonefy/domain/home/repo/song_repo.dart';
import 'package:Tonefy/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SongRepositoryImpl implements SongRepository {
  bool? _isPermissionGranted;
  int? _sdkInt;

  @override
  Future<Either<Exception, List<SongModel>>> fetchSongs() async {
    try {
      if (_isPermissionGranted != true) {
        final deviceInfo = DeviceInfoPlugin();
        final androidInfo = await deviceInfo.androidInfo;
        _sdkInt = androidInfo.version.sdkInt;

        if (_sdkInt! >= 33) {
          var audioStatus = await Permission.audio.status;
          if (!audioStatus.isGranted) {
            audioStatus = await Permission.audio.request();
          }
          _isPermissionGranted = audioStatus.isGranted;
        } else {
          var storageStatus = await Permission.storage.status;
          if (!storageStatus.isGranted) {
            storageStatus = await Permission.storage.request();
          }
          _isPermissionGranted = storageStatus.isGranted;
        }
      }

      if (_isPermissionGranted != true) {
        return Left(Exception('Permission denied'));
      }

      final songs = await getIt<OnAudioQuery>().querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      final filteredSongs = songs
          .where((song) => song.title.isNotEmpty)
          .toList();

      return Right(filteredSongs);
    } catch (e) {
      return Left(Exception('Failed to fetch songs: $e'));
    }
  }
}
