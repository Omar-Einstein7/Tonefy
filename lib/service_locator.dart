import 'package:flutter_template/domain/home/repo/song_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'data/home/repo/song_repository.dart';
import 'domain/home/usecase/get_songs_usecase.dart';
import 'presentation/home/bloc/home_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<OnAudioQuery>(() => OnAudioQuery());
  getIt.registerLazySingleton<SongRepository>(() => SongRepositoryImpl());
  getIt.registerLazySingleton<GetSongsUseCase>(() => GetSongsUseCase());
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
}