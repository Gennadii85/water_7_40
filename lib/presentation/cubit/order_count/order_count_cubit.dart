import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/core/var_manager.dart';
import '../../../core/var_core.dart';
import '../../../data/entity/create_order_address_entity.dart';
import '../../../data/entity/create_order_goods_cart_entity.dart';
import '../../../data/entity/price_entity.dart';
import '../../../data/model/address_model.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/price_model.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';

part 'order_count_state.dart';

class OrderCountCubit extends Cubit<OrderCountState> {
  final int managerID = Hive.box(VarHive.nameBox).get(VarHive.managersID);
  final int? managersPercent =
      Hive.box(VarHive.nameBox).get(VarHive.managersPercent);
  OrderCountCubit()
      : super(
          OrderCountInitState(
            allMoney: 0,
            managerMoney: 0,
            priceEntity: PriceEntity(
              categoriesList: [],
            ),
            goodsList: [],
            addressData: [],
            addressEntity: CreateOrderAddressEntity(
              city: TextEditingController(),
              street: TextEditingController(),
              house: TextEditingController(),
              apartment: TextEditingController(),
              phone: TextEditingController(),
              name: TextEditingController(),
              notes: TextEditingController(),
            ),
          ),
        );

  void initState() {
    emit(
      OrderCountInitState(
        allMoney: 0,
        managerMoney: 0,
        priceEntity: PriceEntity(
          categoriesList: [],
        ),
        goodsList: [],
        addressData: [],
        addressEntity: CreateOrderAddressEntity(
          city: TextEditingController(),
          street: TextEditingController(),
          house: TextEditingController(),
          apartment: TextEditingController(),
          phone: TextEditingController(),
          name: TextEditingController(),
          notes: TextEditingController(),
        ),
      ),
    );
  }

  void getPriceEntity(
    PriceEntity priceEntity,
    List<CityModel> addressData,
  ) {
    emit(
      OrderCountValueState(
        allMoney: state.allMoney,
        managerMoney: 0,
        percentManager: 0,
        priceEntity: priceEntity,
        goodsList: [],
        addressData: addressData,
        addressEntity: state.addressEntity,
      ),
    );
  }

  void addCount(int indexCategories, int index) {
    int value =
        state.priceEntity.categoriesList[indexCategories].countList[index];
    state.priceEntity.categoriesList[indexCategories].countList
        .setAll(index, [value + 1]);
    emit(
      OrderCountValueState(
        allMoney: summaOrder(),
        managerMoney: 0,
        percentManager: 0,
        priceEntity: state.priceEntity,
        goodsList: state.goodsList,
        addressData: state.addressData,
        addressEntity: state.addressEntity,
      ),
    );
  }

  void delCount(int indexCategories, int index) {
    int value =
        state.priceEntity.categoriesList[indexCategories].countList[index];
    if (value == 0) {
      return;
    } else {
      state.priceEntity.categoriesList[indexCategories].countList
          .setAll(index, [value - 1]);
      emit(
        OrderCountValueState(
          allMoney: summaOrder(),
          managerMoney: 0,
          percentManager: 0,
          priceEntity: state.priceEntity,
          goodsList: state.goodsList,
          addressData: state.addressData,
          addressEntity: state.addressEntity,
        ),
      );
    }
  }

  int summaCategory(
    List<PriceModel> priceModelList,
    List<int> countList,
  ) {
    int oneCategoriesAllMoney = 0;
    List<int> oneCategoriesMoneyList = [];
    int index = 0;
    for (var element in priceModelList) {
      int price = element.goodsPrice;
      int count = countList[index];
      int onePriceModelSum = price * count;
      oneCategoriesMoneyList.add(onePriceModelSum);
      index++;
    }
    oneCategoriesAllMoney =
        oneCategoriesMoneyList.reduce((value, element) => value + element);
    return oneCategoriesAllMoney;
  }

  int summaOrder() {
    int allMoney = 0;
    List<int> allSummaCategories = [];
    int summaCategories = 0;
    for (var elem in state.priceEntity.categoriesList) {
      summaCategories = summaCategory(elem.priceModelList, elem.countList);
      allSummaCategories.add(summaCategories);
    }
    allMoney = allSummaCategories.reduce((value, element) => value + element);

    return allMoney;
  }

  List<CreateOrderGoodsEntity> getFinalPrice() {
    List<CreateOrderGoodsEntity> createOrderGoodsEntityList = [];
    for (var element in state.priceEntity.categoriesList) {
      int index = 0;
      List<PriceModel> priceModelList = element.priceModelList;
      for (var elem in element.countList) {
        if (elem > 0) {
          final entity = CreateOrderGoodsEntity(
            goodsName: priceModelList[index].goodsName,
            count: elem,
            price: priceModelList[index].goodsPrice,
          );
          createOrderGoodsEntityList.add(entity);
        }
        index++;
      }
    }
    return createOrderGoodsEntityList;
  }

  void saveFinalPrice() {
    emit(
      OrderCountValueState(
        allMoney: summaOrder(),
        managerMoney: 0,
        percentManager: 0,
        priceEntity: state.priceEntity,
        goodsList: getFinalPrice(),
        addressData: state.addressData,
        addressEntity: state.addressEntity,
      ),
    );
  }

  // int managerProfit() {
  //   int allProfit = 0;
  //   List<int> all = [0];
  //   int countIndex = 0;

  //   for (var elem in prise) {
  //     if (state.listCount[countIndex] != 0) {
  //       if (elem.piecesPercentValueManager != null) {
  //         int moneyPosition =
  //             elem.goodsPrice.toInt() * state.listCount[countIndex];
  //         all.add(moneyPosition * elem.piecesPercentValueManager! ~/ 100);
  //       }
  //       if (elem.piecesMoneyValueManager != null) {
  //         int moneyPosition =
  //             elem.piecesMoneyValueManager! * state.listCount[countIndex];
  //         all.add(moneyPosition);
  //       }
  //       if (elem.existenceMoneyValueManager != null) {
  //         int moneyPosition = elem.existenceMoneyValueManager!;
  //         all.add(moneyPosition);
  //       }
  //       if (elem.managerPercent) {
  //         if (state.percentManager == null) {
  //           all.add(0);
  //         } else {
  //           int moneyPosition =
  //               elem.goodsPrice.toInt() * state.listCount[countIndex];
  //           all.add(moneyPosition * state.percentManager! ~/ 100);
  //         }
  //       } else {
  //         all.add(0);
  //       }
  //     }

  //     countIndex++;
  //   }
  //   allProfit = all.reduce((value, element) => value + element).toInt();
  //   return allProfit;
  // }

  // int carProfit() {
  //   int allProfit = 0;
  //   List<int> all = [];
  //   int countIndex = 0;

  //   for (var elem in prise) {
  //     if (state.listCount[countIndex] != 0) {
  //       if (elem.piecesPercentValueCar != null) {
  //         int moneyPosition =
  //             elem.goodsPrice.toInt() * state.listCount[countIndex];
  //         all.add(moneyPosition * elem.piecesPercentValueCar! ~/ 100);
  //       }
  //       if (elem.piecesMoneyValueCar != null) {
  //         int moneyPosition =
  //             elem.piecesMoneyValueCar! * state.listCount[countIndex];
  //         all.add(moneyPosition);
  //       }
  //       if (elem.existenceMoneyValueCar != null) {
  //         int moneyPosition = elem.existenceMoneyValueCar!;
  //         all.add(moneyPosition);
  //       } else {
  //         all.add(0);
  //       }
  //     }

  //     countIndex++;
  //   }
  //   allProfit = all.reduce((value, element) => value + element).toInt();
  //   return allProfit;
  // }

  void writeOrder(
    String address,
    // String phoneClient,
    bool takeMoney,
    // String? notes,
    int? id,
  ) async {
    Map map = {};
    List<CreateOrderGoodsEntity> goodsList = getFinalPrice();
    for (var element in goodsList) {
      map.addAll({element.goodsName: element.count});
    }

    int? manID;
    if (id == null) {
      manID = managerID;
    } else {
      manID = id;
      RepoAdminGetPost().savePhoneNameAddress(
        state.addressEntity.phone.text,
        state.addressEntity.name.text,
        address,
      );
      //записать номер телефона в базу клиентов
    }

    final model = OrderModel(
      created: DateTime.now().millisecondsSinceEpoch,
      delivered: null,
      summa: state.allMoney,
      managerID: manID,
      managerProfit: 0, // managerProfit(),
      carID: null,
      carProfit: 0, // carProfit(),
      goodsList: map,
      address: address,
      phoneClient: state.addressEntity.phone.text,
      isDone: false,
      takeMoney: takeMoney,
      payMoneyManager: false,
      payMoneyCar: false,
      notes: state.addressEntity.notes.text,
      name: state.addressEntity.name.text,
    );
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc()
        .set(model.toFirebase());

    initState();
  }

  // void updateOrder(
  //   String docID,
  //   String address,
  //   String phoneClient,
  //   bool takeMoney,
  //   String notes,
  //   int manID,
  //   int managerProfit,
  //   int carProfit,
  // ) {
  //   Map map = {};
  //   int countIndex = 0;
  //   for (var elem in state.listCount) {
  //     if (elem > 0) {
  //       map.addAll({prise[countIndex].goodsName: state.listCount[countIndex]});
  //     }
  //     countIndex++;
  //   }
  //   final model = OrderModel(
  //     created: DateTime.now().millisecondsSinceEpoch,
  //     delivered: null,
  //     summa: state.allMoney,
  //     managerID: manID,
  //     managerProfit: managerProfit,
  //     carID: null,
  //     carProfit: carProfit,
  //     goodsList: map,
  //     address: address,
  //     phoneClient: phoneClient,
  //     isDone: false,
  //     takeMoney: takeMoney,
  //     payMoneyManager: false,
  //     payMoneyCar: false,
  //     notes: notes,
  //   );
  //   FirebaseFirestore.instance
  //       .collection(VarManager.orders)
  //       .doc()
  //       .set(model.toFirebase());
  //   FirebaseFirestore.instance
  //       .collection(VarManager.orders)
  //       .doc(docID)
  //       .delete();

  //   initState();
  // }
}
