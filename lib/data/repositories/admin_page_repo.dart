import 'package:cloud_firestore/cloud_firestore.dart';

class RepoAdminPage {
  Future createAdmin(String name, String password) async {
    if (name.isNotEmpty && password.isNotEmpty) {
      final db = FirebaseFirestore.instance;
      db
          .collection('admins')
          .doc(name)
          .set({'name': name, 'password': password});
    } else {
      return;
    }
  }

  Future deleteAdmin(String name) async {
    if (name.isNotEmpty) {
      final db = FirebaseFirestore.instance;
      db.collection('admins').doc(name).delete();
    } else {
      return;
    }
  }

  Future createCars(String name, String password, String carID) async {
    final db = FirebaseFirestore.instance;
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

  Future deleteCars(String docID) async {
    final db = FirebaseFirestore.instance;
    db.collection('cars').doc(docID).delete();
  }
}
