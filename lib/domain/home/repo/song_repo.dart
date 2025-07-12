import 'package:flutter_template/domain/home/entity/song_entity.dart';

import 'package:dartz/dartz.dart';

abstract class SongRepository {
  Future<Either<Exception, List<SongEntity>>> fetchSongs();
}