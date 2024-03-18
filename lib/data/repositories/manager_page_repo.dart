import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/var_core.dart';
import '../model/order_model.dart';
import '../model/price_model.dart';

class RepoManagerPage {
  final db = FirebaseFirestore.instance;
  final int managerID = Hive.box(VarHive.nameBox).get(VarHive.managersID);

  Stream<List<PriceModel>> getPrice() => db.collection('price').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => PriceModel.fromFirebase(doc.data()))
            .toList(),
      );

  Stream<List<OrderModel>> getOrders() => db
      .collection('orders')
      // .where('managerID', isEqualTo: managerID)
      // .where('created', isEqualTo: DateTime.now().month)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirebase(doc.data()))
            .toList(),
      );
}
