import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/order_model.dart';

class RepoAdminCarsReport {
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

  dynamic checkPayMoneyCarTrue(String docID) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docID)
        .update({'payMoneyCar': true});
  }

  dynamic checkPayMoneyCarFalse(String docID) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docID)
        .update({'payMoneyCar': false});
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
