import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tonefy/data/home/repo/favorite_repository.dart';
import 'package:Tonefy/domain/home/entity/favorite_entity.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _favoriteRepository;

  FavoriteCubit(this._favoriteRepository) : super(FavoriteInitial());

  void getFavorites() async {
    try {
      emit(FavoriteLoading());
      final favorites = await _favoriteRepository.getFavorites();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  void addFavorite(SongModel song) async {
    try {
      final favorite = Favorite()
        ..id = song.id.toString()
        ..title = song.title
        ..artist = song.artist ?? ''
        ..filePath = song.data;
      await _favoriteRepository.addFavorite(favorite);
      getFavorites();
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  void removeFavorite(String id) async {
    try {
      await _favoriteRepository.removeFavorite(id);
      getFavorites();
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<bool> isFavorite(String id) async {
    return await _favoriteRepository.isFavorite(id);
  }
}
