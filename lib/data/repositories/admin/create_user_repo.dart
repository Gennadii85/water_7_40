import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';

class RepoCreateUser {
  final db = FirebaseFirestore.instance;

  Future createAdmin(String name, String password) async {
    if (name.isNotEmpty && password.isNotEmpty) {
      db
          .collection('admins')
          .doc(name)
          .set({'name': name, 'password': password});
    } else {
      return;
    }
  }

  Future deleteAdmin(String name) async {
    final snap = await db.collection('admins').get();
    if (snap.docs.map((e) => e['name']).length == 1) {
      return;
    } else {
      db.collection('admins').doc(name).delete();
    }
  }

  Future createCar(
    context,
    String nicknameControl,
    String nameControl,
    String passwordControl,
    String carIDControl,
    String phoneControl,
    String maxControl,
    String notesControl,
  ) async {
    if (carIDControl.isEmpty ||
        nameControl.isEmpty ||
        passwordControl.isEmpty) {
      massage(context, 'Заполните обязательные поля');
      return;
    }
    late int id;
    if (int.tryParse(carIDControl) == null) {
      massage(context, 'ID - только цифры !');
      return;
    }
    id = int.tryParse(carIDControl)!;
    final snap = await db.collection('cars').where('id', isEqualTo: id).get();
    if (snap.docs.map((e) => e['id']).contains(id)) {
      massage(context, 'Такой ID уже существует');
      return;
    }
    db.collection('cars').doc().set(
      {
        'nickname': nicknameControl.isEmpty ? null : nicknameControl,
        'name': nameControl,
        'password': passwordControl,
        'id': id,
        'phone': phoneControl,
        'max': maxControl,
        'notes': notesControl,
      },
    );
    Navigator.of(context).pop();
  }

  Future redactCar(
    context,
    String nicknameControl,
    String passwordControl,
    String phoneControl,
    String maxControl,
    String notesControl,
    String docID,
  ) async {
    if (passwordControl.isEmpty) {
      massage(context, 'Заполните обязательные поля');
      return;
    }
    db.collection('cars').doc(docID).update(
      {
        'nickname': nicknameControl,
        'password': passwordControl,
        'phone': phoneControl,
        'max': maxControl,
        'notes': notesControl,
      },
    );
    Navigator.of(context).pop();
  }

  Future deleteCar(String docID) async {
    db.collection('cars').doc(docID).delete();
  }

  Future createManager(
    context,
    String nicknameControl,
    String nameControl,
    String passwordControl,
    String managerID,
    String phoneControl,
    String percentControl,
    String notesControl,
  ) async {
    if (managerID.isEmpty || nameControl.isEmpty || passwordControl.isEmpty) {
      massage(context, 'Заполните обязательные поля');
      return;
    }
    late int id;
    if (int.tryParse(managerID) == null) {
      massage(context, 'ID - только цифры !');
      return;
    }
    late int? percentManager;
    if (percentControl.isEmpty) {
      percentManager = null;
    } else {
      if (int.tryParse(percentControl) != null) {
        percentManager = int.tryParse(percentControl);
      } else {
        return;
      }
    }
    id = int.tryParse(managerID)!;
    final snap =
        await db.collection('managers').where('id', isEqualTo: id).get();
    if (snap.docs.map((e) => e['id']).contains(id)) {
      massage(context, 'Такой ID уже существует');
      return;
    }
    db.collection('managers').doc().set(
      {
        'nickname': nicknameControl,
        'name': nameControl,
        'password': passwordControl,
        'id': id,
        'phone': phoneControl,
        'percent': percentManager,
        'notes': notesControl,
      },
    );
    Navigator.of(context).pop();
  }

  Future redactManager(
    context,
    String nicknameControl,
    String passwordControl,
    String phoneControl,
    String percentControl,
    String notesControl,
    String docID,
  ) async {
    if (passwordControl.isEmpty) {
      massage(context, 'Заполните обязательные поля');
      return;
    }
    late int? percentManager;
    if (percentControl.isEmpty) {
      percentManager = null;
    } else {
      if (int.tryParse(percentControl) != null) {
        percentManager = int.tryParse(percentControl);
      } else {
        return;
      }
    }
    db.collection('managers').doc(docID).update(
      {
        'nickname': nicknameControl,
        'password': passwordControl,
        'phone': phoneControl,
        'percent': percentManager,
        'notes': notesControl,
      },
    );
    Navigator.of(context).pop();
  }

  Future deleteManager(String docID) async {
    db.collection('managers').doc(docID).delete();
  }

  Future massage(BuildContext context, String massage) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(massage),
        actions: [
          AdminButtons(
            text: 'OK',
            function: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
