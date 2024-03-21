import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/var_core.dart';
import '../model/order_model.dart';
import '../model/price_model.dart';

class RepoManagerPage {
  final db = FirebaseFirestore.instance;
  final int managerID = Hive.box(VarHive.nameBox).get(VarHive.managersID);

  Stream<List<PriceModel>> getPrice() => db
      .collection('price')
      .orderBy('goodsName', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => PriceModel.fromFirebase(doc.data(), doc.id))
            .toList(),
      );

  Stream<List<OrderModel>> getOrders() => db
      .collection('orders')
      .orderBy('created', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirebase(doc.data()))
            .toList(),
      );
}
