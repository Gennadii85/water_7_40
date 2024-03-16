import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../core/var_core.dart';
import '../../presentation/pages/managers_page.dart';
import '../../presentation/pages/registration_page.dart';
import '../model/managers_model.dart';

class RepoIdenticManagers {
/* 
key = VarHive.managers
route = MaterialPageRoute(builder: (context) => const ManagersPage()),

positionCompany == boxKey == VarHive. или admins, или cars, или managers

*/
  dynamic checkUser(context, String boxKey, MaterialPageRoute route) async {
    if (Hive.box(VarHive.nameBox).containsKey(boxKey)) {
      Map data = Hive.box(VarHive.nameBox).get(boxKey);
      ManagersModel model = await getDBRegistrationData(boxKey, data);
      if (data.entries.first.key == model.name &&
          data.entries.first.value == model.password) {
        Navigator.of(context).push(route);
        if (model.percent!.isNotEmpty) {
          Hive.box(VarHive.nameBox).put(VarHive.managersPercent, model.percent);
        }
      } else {
        _massage(
          context,
          'Неверный логин или пароль. Попробуйте снова или обратитесь к администратору',
          MaterialPageRoute(
            builder: (context) => RegistrationPage(
              positionCompany: boxKey,
              route: route,
            ),
          ),
        );
      }
    } else {
      _massage(
        context,
        'Введите логин или пароль.',
        MaterialPageRoute(
          builder: (context) => RegistrationPage(
            positionCompany: boxKey,
            route: route,
          ),
        ),
      );
    }
  }

  // dynamic loginManager(context) async {
  //   if (Hive.box(VarHive.nameBox).containsKey(VarHive.managers)) {
  //     Map data = Hive.box(VarHive.nameBox).get(VarHive.managers);
  //     ManagersModel model = await getDBRegistrationData(VarHive.managers, data);
  //     if (data.entries.first.key == model.name &&
  //         data.entries.first.value == model.password) {
  //       Hive.box(VarHive.nameBox).put(VarHive.managersPercent, model.percent);
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => const ManagersPage()),
  //       );
  //     } else {
  //       _massage(
  //         context,
  //         'Неверный логин или пароль. Попробуйте снова или обратитесь к администратору',
  //         MaterialPageRoute(
  //           builder: (context) => const RegistrationPage(),
  //         ),
  //       );
  //     }
  //   } else {
  //     _massage(
  //       context,
  //       'Введите логин или пароль.',
  //       MaterialPageRoute(
  //         builder: (context) => const RegistrationPage(),
  //       ),
  //     );
  //   }
  // }

  dynamic getDBRegistrationData(String boxKey, Map dataMap) async {
    Map<String, dynamic> data = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(boxKey)
        .where('name', isEqualTo: dataMap.entries.first.key)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot snapshot = querySnapshot.docs.first;
      data = snapshot.data() as Map<String, dynamic>;
      ManagersModel model = ManagersModel.fromJson(data);
      return model;
    } else {
      return ManagersModel(
        name: 'name',
        password: 'password',
        id: '0',
        percent: '0',
      );
    }
  }

  dynamic checkRegistrationUser(
    context,
    String login,
    String password,
    String positionCompany,
    MaterialPageRoute route,
  ) async {
    Map<String, dynamic> dataMap = {login: password};
    ManagersModel model = await getDBRegistrationData(positionCompany, dataMap);
    if (dataMap.entries.first.key == model.name &&
        dataMap.entries.first.value == model.password) {
      Hive.box(VarHive.nameBox).put(positionCompany, dataMap);
      if (model.percent!.isNotEmpty) {
        Hive.box(VarHive.nameBox).put(VarHive.managersPercent, model.percent);
      }
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ManagersPage()),
      );
    } else {
      _massage(
        context,
        'Неверный логин или пароль.',
        MaterialPageRoute(
          builder: (context) => RegistrationPage(
            positionCompany: positionCompany,
            route: route,
          ),
        ),
      );
    }
  }

  Future<dynamic> _massage(context, String text, MaterialPageRoute route) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(text),
        actions: [
          AdminButtons(
            text: 'OK',
            function: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(route);
            },
          ),
        ],
      ),
    );
  }
}
