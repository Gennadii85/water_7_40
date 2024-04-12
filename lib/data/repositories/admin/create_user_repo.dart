import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../presentation/pages/widgets/massage.dart';

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
      Navigator.of(context).pop();
      Massage().massage(context, 'Заполните нужные поля');
      return;
    }
    late int id;
    if (int.tryParse(carIDControl) == null) {
      Massage().massage(context, 'ID - только цифры !');
      return;
    }
    id = int.tryParse(carIDControl)!;
    final snap = await db.collection('cars').where('id', isEqualTo: id).get();
    if (snap.docs.map((e) => e['id']).contains(id)) {
      Massage().massage(context, 'Такой ID уже существует');
      return;
    }
    db.collection('cars').doc().set(
      {
        'nickname': nicknameControl,
        'name': nameControl,
        'password': passwordControl,
        'id': id,
        'phone': phoneControl,
        'max': maxControl,
        'notes': notesControl,
      },
    );
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
      Navigator.of(context).pop();
      Massage().massage(context, 'Заполните нужные поля');
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
  }

  Future deleteCar(String docID) async {
    db.collection('cars').doc(docID).delete();
  }

  Future createManager(
    context,
    String name,
    String password,
    String phone,
    String managerID,
    String percent,
  ) async {
    late int id;
    late int? percentManager;
    if (managerID.isEmpty) {
      return;
    }
    if (percent.isEmpty) {
      percentManager = null;
    } else {
      if (int.tryParse(percent) != null) {
        percentManager = int.tryParse(percent);
      } else {
        return;
      }
    }
    id = int.tryParse(managerID) ?? 1;
    final snap =
        await db.collection('managers').where('id', isEqualTo: id).get();
    if (snap.docs.map((e) => e['id']).contains(id)) {
      Massage().massage(context, 'Такой ID уже существует');
      return;
    }
    if (name.isNotEmpty && password.isNotEmpty) {
      db.collection('managers').doc().set(
        {
          'name': name,
          'password': password,
          'phone': phone,
          'id': id,
          'percent': percentManager,
        },
      );
    }
  }

  Future deleteManager(String docID) async {
    db.collection('managers').doc(docID).delete();
  }
}
