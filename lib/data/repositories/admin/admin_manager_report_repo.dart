import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/order_model.dart';
import '../../model/write_address_model.dart';

class RepoAdminManagersReport {
  final db = FirebaseFirestore.instance;

  Stream<List<OrderModel>> getAllOrders(
    DateTime startDate,
    DateTime finishDate,
  ) {
    return db
        .collection('orders')
        .orderBy('created', descending: true)
        .where(
          'created',
          isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch,
        )
        .where(
          'created',
          isLessThanOrEqualTo: finishDate.millisecondsSinceEpoch,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<WriteAddressModel>> getAllWriteAddress() {
    return db.collection('managerAddress').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => WriteAddressModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }
}
