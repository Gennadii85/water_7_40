import 'package:cloud_firestore/cloud_firestore.dart';
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
      return;
    }
    late int id;
    id = int.tryParse(carID) ?? 1;
    final snap = await db.collection('cars').where('id', isEqualTo: id).get();
    if (snap.docs.map((e) => e['id']).contains(id)) {
      Massage().massage(context, 'Такой ID уже существует');
      return;
    }
    if (name.isNotEmpty && password.isNotEmpty) {
      db.collection('cars').doc().set(
        {'name': name, 'password': password, 'id': id},
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
