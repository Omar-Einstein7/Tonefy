part of 'home_cubit.dart';


abstract class HomeState  {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SongModel> songs;

   HomeLoaded(this.songs);


}

class HomeError extends HomeState {
  final String message;

   HomeError(this.message);

 
}