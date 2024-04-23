import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/order_model.dart';
import '../../model/write_address_model.dart';

class RepoAdminManagersReport {
  final db = FirebaseFirestore.instance;

  Stream<List<OrderModel>> getStartFinishOrders(
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

  dynamic checkPayMoneyManagerTrue(String docID) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docID)
        .update({'payMoneyManager': true});
  }

  dynamic checkPayMoneyManagerFalse(String docID) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docID)
        .update({'payMoneyManager': false});
  }

  dynamic checkPayTrue(String docID) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docID)
        .update({'isDone': true});
  }

  dynamic checkPayFalse(String docID) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docID)
        .update({'isDone': false});
  }
}
