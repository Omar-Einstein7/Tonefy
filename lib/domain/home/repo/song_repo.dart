import 'package:Tonefy/domain/home/entity/song_entity.dart';

import 'package:dartz/dartz.dart';

import 'package:dartz/dartz.dart';
import 'package:on_audio_query/on_audio_query.dart';

abstract class SongRepository {
  Future<Either<Exception, List<SongModel>>> fetchSongs();
}