import 'package:flutter_template/domain/home/entity/song_entity.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongMapper {
  static SongEntity toEntity(SongModel song) {
    return SongEntity(
      id: song.id,
      title: song.title,
      artist: song.artist ?? 'Unknown Artist'
    );
  }
}
