import 'dart:typed_data';
import 'package:on_audio_query/on_audio_query.dart';
import '../../service_locator.dart';

class ArtworkCacheService {
  final Map<int, Uint8List?> _cache = {};
  final OnAudioQuery _audioQuery = getIt<OnAudioQuery>();

  Future<Uint8List?> getArtwork(int id) async {
    if (_cache.containsKey(id)) {
      return _cache[id];
    }

    final Uint8List? bytes = await _audioQuery.queryArtwork(
      id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 200, // Reasonable size for thumbnails
      quality: 50,
    );

    _cache[id] = bytes;
    return bytes;
  }

  void clearCache() {
    _cache.clear();
  }
}
