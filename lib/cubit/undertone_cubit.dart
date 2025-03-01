import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:p13/model/undertone_model.dart';

part 'undertone_state.dart';

class UndertoneCubit extends Cubit<UndertoneState> {
  UndertoneCubit() : super(UndertoneInitial());

  String getRandomSeason() {
    // List of the four seasons
    List<String> seasons = ['spring', 'summer', 'autumn', 'winter'];

    // Generate a random index
    Random random = Random();
    int index = 3;

    // Return the season at the random index
    return seasons[index];
  }

  var hiveData = Hive.box<UndertoneModel>("undertone");
  fun(UndertoneModel undertone) async {
    try {
      await hiveData.add(undertone);
      emit(UndertoneSuccessed());
    } catch (e) {
      emit(UndertoneFailed());
    }
  }
}
