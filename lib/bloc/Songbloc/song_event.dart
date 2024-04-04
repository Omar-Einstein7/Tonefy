import 'package:equatable/equatable.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:tonefy/data/song_model.dart';

abstract class SongEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class AddtoFav extends SongEvents {
  final SongModel songModel;

  AddtoFav(this.songModel);

  @override
  List<Object> get props => [songModel];
}

class RemoveFromFav extends SongEvents {
  final SongModel songModel;

  RemoveFromFav(this.songModel);

  @override
  List<Object> get props => [songModel];
}