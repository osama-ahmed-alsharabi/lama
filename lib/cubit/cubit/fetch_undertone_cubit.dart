import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';
import 'package:p13/model/undertone_model.dart';

part 'fetch_undertone_state.dart';

class FetchUndertoneCubit extends Cubit<FetchUndertoneState> {
  FetchUndertoneCubit() : super(FetchUndertoneInitial());

  var hiveData = Hive.box<UndertoneModel>("undertone");
  UndertoneModel? value;
  UndertoneModel? fetch() {
    try {
      value = hiveData.values.first;
      // String? undertone = value.season;

      // emit(FetchUndertonehasData());
      if (value?.season.isNotEmpty != null) {
        emit(FetchUndertonehasData());
        return value;
      } else {
        emit(FetchUndertoneNoData());
        return value;
      }
    } catch (e) {
      emit(FetchUndertoneNoData());
      return null;
      // throw Exception(e);
    }
  }
}
