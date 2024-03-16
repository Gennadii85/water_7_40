import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/price_model.dart';

class RepoManagerPage {
  final db = FirebaseFirestore.instance;

  Stream<List<PriceModel>> getPrice() => db.collection('price').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => PriceModel.fromFirebase(doc.data()))
            .toList(),
      );
}
