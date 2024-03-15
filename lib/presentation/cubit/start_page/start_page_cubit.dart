import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/var_core.dart';
import '../../../data/model/managers_model.dart';
import '../../../data/repositories/core_repo.dart';
import '../../../data/repositories/managers_identic_repo.dart';

part 'start_page_state.dart';

class StartPageCubit extends Cubit<StartPageState> {
  StartPageCubit() : super(StartPageInitial());

  dynamic getStarted() async {
    if (RepoCore().identificationUser().length == 1) {
      if (Hive.box(VarHive.nameBox).containsKey(VarHive.managers)) {
        var check = await checkManager();
        emit(check);
      }
      if (Hive.box(VarHive.nameBox).containsKey(VarHive.cars)) {
        emit(StartPageCar());
      }
      if (Hive.box(VarHive.nameBox).containsKey(VarHive.admins)) {
        emit(StartPageAdmin());
      }
    } else {
      emit(StartPageInitial());
    }
  }

  dynamic checkManager() async {
    Map data = Hive.box(VarHive.nameBox).get(VarHive.managers);
    ManagersModel model = await RepoIdenticManagers()
        .getDBRegistrationData(VarHive.managers, data);
    if (data.entries.first.key == model.name &&
        data.entries.first.value == model.password) {
      return StartPageManager();
    }
    return StartPageInitial();
  }
}
