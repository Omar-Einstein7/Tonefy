import 'package:Tonefy/domain/home/repo/song_repo.dart';

import 'package:get_it/get_it.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'data/home/repo/song_repository.dart';
import 'domain/home/usecase/get_songs_usecase.dart';
import 'presentation/home/bloc/home_cubit.dart';
import 'presentation/home/bloc/song_player_cubit.dart';
import 'presentation/home/bloc/favorite_cubit.dart';
import 'presentation/home/bloc/playlist_cubit.dart';
// import 'presentation/home/bloc/recent_cubit.dart';
import 'package:Tonefy/data/home/repo/favorite_repository.dart';
import 'package:Tonefy/domain/home/entity/favorite_entity.dart';
import 'package:hive/hive.dart';

final GetIt getIt = GetIt.instance;


void setupServiceLocator() {
  getIt.registerLazySingleton<OnAudioQuery>(() => OnAudioQuery());
  getIt.registerLazySingleton<SongRepository>(() => SongRepositoryImpl());
  getIt.registerLazySingleton<GetSongsUseCase>(() => GetSongsUseCase());
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
  getIt.registerLazySingleton<SongPlayerCubit>(() => SongPlayerCubit());
  getIt.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(Hive.box<Favorite>('favorites')));
  getIt.registerLazySingleton<FavoriteCubit>(
      () => FavoriteCubit(getIt<FavoriteRepository>()));
  getIt.registerLazySingleton<PlaylistCubit>(() => PlaylistCubit());
  // getIt.registerLazySingleton<RecentCubit>(
  //   () => RecentCubit(getIt<SongPlayerCubit>()),
  // );
}
