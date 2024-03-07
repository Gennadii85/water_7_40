import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RepoAdminPage {
  // Future getAdminList() async {
  //   final db = FirebaseFirestore.instance;
  //   final listAdmins = db.collection('admins').snapshots();
  //   return listAdmins;
  // }

  Future createAdmin(String name, String password) async {
    if (name.isNotEmpty || password.isNotEmpty) {
      final db = FirebaseFirestore.instance;
      db.collection('admins').doc(name).set({'name': name, 'pass': password});
    } else {
      return;
    }
  }

  Future update() async {
    return;
  }

  Future assignDriver() async {
    return;
  }

  Future freeOrder() async {
    return;
  }

  Future assignedOrder() async {
    return;
  }
}
