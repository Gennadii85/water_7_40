import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/price_entity.dart';
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

  PriceEntity setPriceEntity(List<PriceModel> price) {
    List<PriceCategories> categoriesList = [];
    PriceEntity priceEntity = PriceEntity(categoriesList: categoriesList);
    List<String> categoriesNameList =
        price.map((e) => e.categoryName).toSet().toList();
    for (var elem in categoriesNameList) {
      List<PriceModel> priceModelList =
          price.where((element) => element.categoryName == elem).toList();
      List<int> countList = List.generate(priceModelList.length, (index) => 0);
      String nameCategories = elem;
      PriceCategories categoriesEntity = PriceCategories(
        nameCategories: nameCategories,
        priceModelList: priceModelList,
        countList: countList,
      );
      categoriesList.add(categoriesEntity);
    }
    return priceEntity;
  }
}
