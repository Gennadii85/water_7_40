import 'package:cloud_firestore/cloud_firestore.dart';

import '../../entity/car_cargo_entity.dart';
import '../../model/order_model.dart';

class RepoAdminGeneralReport {
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

  int summaAllMoney(List<OrderModel> list) {
    List<int> summaList = [];
    int summaAllMoney = 0;
    if (list.isNotEmpty) {
      for (var element in list) {
        summaList.add(element.summa.toInt());
      }
      summaAllMoney = summaList.reduce((value, element) => value + element);
    }
    return summaAllMoney;
  }

  int carProfit(List<OrderModel> list) {
    List<int> summaList = [];
    int summaAllMoney = 0;
    if (list.isNotEmpty) {
      for (var element in list) {
        summaList.add(element.carProfit ?? 0);
      }
      summaAllMoney = summaList.reduce((value, element) => value + element);
    }
    return summaAllMoney;
  }

  int managerProfit(List<OrderModel> list) {
    List<int> summaList = [];
    int summaAllMoney = 0;
    if (list.isNotEmpty) {
      for (var element in list) {
        summaList.add(element.managerProfit ?? 0);
      }
      summaAllMoney = summaList.reduce((value, element) => value + element);
    }
    return summaAllMoney;
  }

  List<CarCargoEntity> allCityGoods(List<OrderModel> list) {
    if (list.isEmpty) {
      return [];
    }
    List<String> listName = [];
    List<int> listCount = [];
    for (var element in list) {
      final Map goodsMap = element.goodsList;
      for (var element in goodsMap.entries) {
        final entity = CarCargoEntity(
          goodsName: element.key,
          count: element.value,
        );
        if (listName.contains(entity.goodsName)) {
          int index = listName.indexOf(entity.goodsName);
          int val = listCount.elementAt(index);
          listCount.setAll(index, {val + entity.count});
        } else {
          listName.add(entity.goodsName);
          listCount.add(entity.count);
        }
      }
    }
    List<CarCargoEntity> listEntity = [];
    int index = 0;
    for (var element in listName) {
      listEntity
          .add(CarCargoEntity(goodsName: element, count: listCount[index]));
      index++;
    }
    print(listName);
    return listEntity;
  }
}
