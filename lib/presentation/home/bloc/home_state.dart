part of 'home_cubit.dart';

abstract class HomeState  {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SongEntity> songs;

   HomeLoaded(this.songs);


}

class HomeError extends HomeState {
  final String message;

   HomeError(this.message, {required String e});

 
}