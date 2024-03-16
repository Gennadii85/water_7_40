import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/var_core.dart';
import '../../../data/model/users_registration_model.dart';
import '../../../data/repositories/core_repo.dart';
import '../../../data/repositories/users_identic_repo.dart';

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
        var check = await checkCars();
        emit(check);
      }
      if (Hive.box(VarHive.nameBox).containsKey(VarHive.admins)) {
        var check = await checkAdmins();
        emit(check);
      }
    } else {
      emit(StartPageInitial());
    }
  }

  dynamic checkManager() async {
    Map data = Hive.box(VarHive.nameBox).get(VarHive.managers);
    UsersRegistrationModel model =
        await RepoIdenticUsers().getDBRegistrationData(VarHive.managers, data);
    if (data.entries.first.key == model.name &&
        data.entries.first.value == model.password) {
      return StartPageManager();
    }
    return StartPageInitial();
  }

  dynamic checkCars() async {
    Map data = Hive.box(VarHive.nameBox).get(VarHive.cars);
    UsersRegistrationModel model =
        await RepoIdenticUsers().getDBRegistrationData(VarHive.cars, data);
    if (data.entries.first.key == model.name &&
        data.entries.first.value == model.password) {
      return StartPageCar();
    }
    return StartPageInitial();
  }

  dynamic checkAdmins() async {
    Map data = Hive.box(VarHive.nameBox).get(VarHive.admins);
    UsersRegistrationModel model =
        await RepoIdenticUsers().getDBRegistrationData(VarHive.admins, data);
    if (data.entries.first.key == model.name &&
        data.entries.first.value == model.password) {
      return StartPageAdmin();
    }
    return StartPageInitial();
  }
}
