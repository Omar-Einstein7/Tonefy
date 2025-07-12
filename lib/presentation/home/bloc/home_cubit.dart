import 'package:bloc/bloc.dart';
import 'package:Tonefy/service_locator.dart';



import '../../../domain/home/entity/song_entity.dart';
import '../../../domain/home/usecase/get_songs_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  void fetchSongs() async {
    var returnedData = await getIt<GetSongsUseCase>().call();
    returnedData.fold((error) {
      emit(HomeError(error.toString(), e: error.toString()));
    }, (data) {
      emit(HomeLoaded(data));
    });
  }
}
