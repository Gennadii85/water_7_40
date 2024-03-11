import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/price_entity.dart';

class RepoManagerPage {
  final db = FirebaseFirestore.instance;
  Stream<List<PriceEntity>> getPrice() =>
      db.collection('price').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => PriceEntity.fromJson(doc.data()))
                .toList(),
          );
}
