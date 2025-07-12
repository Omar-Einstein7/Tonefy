// import 'package:dartz/dartz.dart';
// import 'package:Tonefy/domain/home/repo/song_repo.dart';

// import '../entity/song_entity.dart';

// abstract class GetSongsUseCase {
//   Future<Either<Exception, List<SongEntity>>> call();
// }

// class GetSongsUseCaseImpl implements GetSongsUseCase {
//   final SongRepository _songRepository;

//   GetSongsUseCaseImpl(this._songRepository);

//   @override
//   Future<Either<Exception, List<SongEntity>>> call() {
//     return _songRepository.fetchSongs();
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:Tonefy/core/usecase/usecase.dart';
import 'package:Tonefy/domain/home/repo/song_repo.dart';
import 'package:Tonefy/service_locator.dart';
import 'package:on_audio_query/on_audio_query.dart';



class GetSongsUseCase extends Usecase<Either<Exception, List<SongModel>>, dynamic> {
  @override
  Future<Either<Exception, List<SongModel>>> call({params}) async {
    return await getIt<SongRepository>().fetchSongs();
  }
}


