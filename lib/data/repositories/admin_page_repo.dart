import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../presentation/pages/widgets/massage.dart';

class RepoAdminPage {
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

  Future createCar(context, String name, String password, String carID) async {
    if (carID.isEmpty) {
      Massage().massage(context, 'Укажите ID');
      return;
    }
    late int id;
    id = int.tryParse(carID) ?? 1;
    final snap =
        await db.collection('cars').where('carID', isEqualTo: id).get();
    if (snap.docs.map((e) => e['carID']).contains(id)) {
      Massage().massage(context, 'Такой ID уже существует');
      return;
    }
    if (name.isNotEmpty && password.isNotEmpty) {
      db.collection('cars').doc().set(
        {'name': name, 'password': password, 'carID': id},
      );
    }
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
    if (managerID.isEmpty) {
      Massage().massage(context, 'Укажите ID');
      return;
    }
    late int id;
    id = int.tryParse(managerID) ?? 1;
    final snap =
        await db.collection('managers').where('managerID', isEqualTo: id).get();
    if (snap.docs.map((e) => e['managerID']).contains(id)) {
      Massage().massage(context, 'Такой ID уже существует');
      return;
    }
    if (name.isNotEmpty && password.isNotEmpty) {
      db.collection('managers').doc().set(
        {
          'name': name,
          'password': password,
          'phone': phone,
          'managerID': id,
          'percent': percent,
        },
      );
    }
  }

  Future deleteManager(String docID) async {
    db.collection('managers').doc(docID).delete();
  }
}
