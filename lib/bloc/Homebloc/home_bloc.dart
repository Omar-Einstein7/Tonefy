import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
//import 'package:meloplay/data/repositories/home_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tonefy/data/repo/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    final repository = HomeRepository();
    on<GetSongsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final songs = await repository.getSongs();
        emit(
          SongsLoaded(songs),
        );
      } catch (e, s) {
        debugPrintStack(label: e.toString(), stackTrace: s);
        emit(HomeError(e.toString()));
      }
    });

  }
}
