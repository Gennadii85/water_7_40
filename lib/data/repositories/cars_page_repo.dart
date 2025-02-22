import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/order_model.dart';

class RepoCarPage {
  final db = FirebaseFirestore.instance;

  final int lastFifeDay = DateTime.now().millisecondsSinceEpoch -
      ((DateTime.now().hour * 3600000) - 24 * 3600000 * 4);

  Stream<List<OrderModel>> getTodayOrders(int carID) {
    return db
        .collection('orders')
        .where('delivered', isEqualTo: null)
        .where('created', isLessThan: lastFifeDay)
        .where('carID', isEqualTo: carID)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  dynamic markDelivered(String docID) {
    db
        .collection('orders')
        .doc(docID)
        .update({'delivered': DateTime.now().millisecondsSinceEpoch});
  }
}
