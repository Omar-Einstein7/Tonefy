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

class GetSongsUseCase extends Usecase<Either, dynamic> {
 @override
  Future<Either> call({params}) async {
    return await getIt<SongRepository>().fetchSongs();
  }
}


