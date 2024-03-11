import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future createCar(String name, String password, String carID) async {
    final snap =
        await db.collection('cars').where('carID', isEqualTo: carID).get();
    if (snap.docs.map((e) => e['carID']).contains(carID)) {
      return;
      //! CarMassage().massage(context);
    }
    if (name.isNotEmpty && password.isNotEmpty && carID.isNotEmpty) {
      db.collection('cars').doc().set(
        {'name': name, 'password': password, 'carID': carID},
      );
    }
  }

  Future deleteCar(String docID) async {
    db.collection('cars').doc(docID).delete();
  }

  Future createManager(
    String name,
    String password,
    String phone,
    String managerID,
    String percent,
  ) async {
    final snap = await db
        .collection('managers')
        .where('managerID', isEqualTo: managerID)
        .get();
    if (snap.docs.map((e) => e['managerID']).contains(managerID)) {
      return;
      //! CarMassage().massage(context);
    }
    if (name.isNotEmpty && password.isNotEmpty && managerID.isNotEmpty) {
      db.collection('managers').doc().set(
        {
          'name': name,
          'password': password,
          'phone': phone,
          'managerID': managerID,
          'percent': percent,
        },
      );
    }
  }

  Future deleteManager(String docID) async {
    db.collection('managers').doc(docID).delete();
  }
}
