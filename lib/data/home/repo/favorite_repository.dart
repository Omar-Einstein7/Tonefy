
import 'package:hive/hive.dart';
import 'package:Tonefy/domain/home/entity/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<void> addFavorite(Favorite favorite);
  Future<void> removeFavorite(String id);
  Future<List<Favorite>> getFavorites();
  Future<bool> isFavorite(String id);
}

class FavoriteRepositoryImpl implements FavoriteRepository {
  final Box<Favorite> _favoriteBox;

  FavoriteRepositoryImpl(this._favoriteBox);

  @override
  Future<void> addFavorite(Favorite favorite) async {
    await _favoriteBox.put(favorite.id, favorite);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await _favoriteBox.delete(id);
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    return _favoriteBox.values.toList();
  }

  @override
  Future<bool> isFavorite(String id) async {
    return _favoriteBox.containsKey(id);
  }
}
