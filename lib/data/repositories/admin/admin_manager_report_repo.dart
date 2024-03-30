import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/order_model.dart';

class RepoAdminManagersReport {
  final db = FirebaseFirestore.instance;

  Stream<List<OrderModel>> getAllOrders(
    int managerID,
    DateTime startDate,
    DateTime finishDate,
  ) {
    return db
        .collection('orders')
        // .orderBy('created', descending: true)
        .where('managerID', isEqualTo: managerID)
        // .where('created', isGreaterThanOrEqualTo: 1)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }
}
