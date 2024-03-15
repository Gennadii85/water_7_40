import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../core/var_core.dart';
import '../../presentation/pages/managers_page.dart';
import '../../presentation/pages/registration_page.dart';
import '../model/managers_model.dart';

class RepoIdenticManagers {
  dynamic loginManager(context) async {
    if (Hive.box(VarHive.nameBox).containsKey(VarHive.managers)) {
      Map data = Hive.box(VarHive.nameBox).get(VarHive.managers);
      ManagersModel model = await getDBRegistrationData(VarHive.managers, data);
      if (data.entries.first.key == model.name &&
          data.entries.first.value == model.password) {
        Hive.box(VarHive.nameBox).put(VarHive.managersPercent, model.percent);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ManagersPage()),
        );
      } else {
        _massage(
          context,
          'Неверный логин или пароль. Попробуйте снова или обратитесь к администратору',
          MaterialPageRoute(
            builder: (context) => const RegistrationPage(),
          ),
        );
      }
    } else {
      _massage(
        context,
        'Введите логин или пароль.',
        MaterialPageRoute(
          builder: (context) => const RegistrationPage(),
        ),
      );
    }
  }

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

  dynamic registrationManager(context, String login, String password) async {
    Map<String, dynamic> dataMap = {login: password};
    ManagersModel model =
        await getDBRegistrationData(VarHive.managers, dataMap);
    if (dataMap.entries.first.key == model.name &&
        dataMap.entries.first.value == model.password) {
      Hive.box(VarHive.nameBox).put(VarHive.managers, dataMap);
      Hive.box(VarHive.nameBox).put(VarHive.managersPercent, model.percent);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ManagersPage()),
      );
    } else {
      _massage(
        context,
        'Неверный логин или пароль.',
        MaterialPageRoute(builder: (context) => const RegistrationPage()),
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
