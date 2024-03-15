import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/core/var_core.dart';

class RepoCore {
  List<bool> identificationUser() {
    bool manager = Hive.box(VarHive.nameBox).containsKey(VarHive.managers);
    bool car = Hive.box(VarHive.nameBox).containsKey(VarHive.cars);
    bool admin = Hive.box(VarHive.nameBox).containsKey(VarHive.admins);
    List<bool> list = [manager, car, admin];
    List<bool> finalList = [];
    for (var elem in list) {
      if (elem) {
        finalList.add(elem);
      }
    }
    return finalList;
  }
}
