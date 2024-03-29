import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/order_model.dart';
import '../model/price_model.dart';

class RepoManagerPage {
  final db = FirebaseFirestore.instance;
  final int today =
      DateTime.now().millisecondsSinceEpoch - DateTime.now().hour * 3600000;

  Stream<List<PriceModel>> getPrice() {
    return db
        .collection('price')
        .orderBy('goodsName', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PriceModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<OrderModel>> getTodayOrders() {
    return db
        .collection('orders')
        .orderBy('created', descending: true)
        .where('created', isGreaterThan: today)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<int?> checkAddress(String address) async {
    int? id;
    await db.collection('managerAddress').doc(address).get().then(
      (doc) {
        Map? data = doc.data() ?? {};
        String? idData = data['managerID'] ?? '';
        id = int.tryParse(idData!);
      },
      onError: (e) => id = null,
    );
    return id;
  }
}
