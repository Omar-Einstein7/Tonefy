import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonefy/bloc/Songbloc/song_event.dart';
import 'package:tonefy/bloc/Songbloc/song_state.dart';
import 'package:tonefy/data/song_model.dart';

class SongBloc extends Bloc<SongEvents, SongState> {
  SongBloc() : super(SongState([])) {
    _loadFromSharedPreferences();
    on<SongEvents>(_mapEventToState);
  }

  Future<void> _mapEventToState(
      SongEvents events, Emitter<SongState> emit) async {
    if (events is AddtoFav) {
      final updatedFav = List<SongModel>.from(state.Songitems)
        ..add(events.songModel);
      emit(SongState(updatedFav));
    } else if (events is RemoveFromFav) {
      final updatedFav = List<SongModel>.from(state.Songitems)
        ..remove(events.songModel);
      emit(SongState(updatedFav));
    }
  }

  Future<void> _loadFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Load the saved data from SharedPreferences
      List<String>? favSongs = prefs.getStringList('favSongs');
      if (favSongs != null) {
        // Convert the loaded data back to List<SongModel>
        List<SongModel> songList = favSongs
            .map((jsonString) => SongModel(json.decode(jsonString)))
            .toList();
        emit(SongState(songList));
      }
    } catch (e) {
      // Handle errors if any
      print("Error loading data from SharedPreferences: $e");
    }
  }

  Future<void> _saveToSharedPreferences(List<SongModel> updatedFav) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Convert List<SongModel> to a format suitable for SharedPreferences
      List<String> jsonStringList =
          updatedFav.map((songModel) => json.encode(songModel)).toList();
      // Save the data to SharedPreferences
      await prefs.setStringList('favSongs', jsonStringList);
    } catch (e) {
      // Handle errors if any
      print("Error saving data to SharedPreferences: $e");
    }
  }
}
