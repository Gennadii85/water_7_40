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
              time: TextEditingController(),
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
          time: TextEditingController(),
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

  PriceModel getPriceModel(String goodsName) {
    List<PriceModel> list = [];
    for (var element in state.priceEntity.categoriesList) {
      list.addAll(element.priceModelList);
    }
    return list.where((element) => element.goodsName == goodsName).first;
  }

  int managerProfit() {
    int allProfit = 0;
    List<int> all = [0];

    for (var elem in state.goodsList) {
      final PriceModel model = getPriceModel(elem.goodsName);

      if (model.piecesPercentValueManager != null) {
        int moneyPosition = elem.price.toInt() * elem.count;
        all.add(moneyPosition * model.piecesPercentValueManager! ~/ 100);
      }
      if (model.piecesMoneyValueManager != null) {
        int moneyPosition = model.piecesMoneyValueManager! * elem.count;
        all.add(moneyPosition);
      }
      if (model.existenceMoneyValueManager != null) {
        int moneyPosition = model.existenceMoneyValueManager!;
        all.add(moneyPosition);
      }
      if (model.managerPercent) {
        if (managersPercent == null) {
          all.add(0);
        } else {
          int moneyPosition = elem.price.toInt() * elem.count;
          all.add(moneyPosition * managersPercent! ~/ 100);
        }
      } else {
        all.add(0);
      }
    }
    allProfit = all.reduce((value, element) => value + element).toInt();
    return allProfit;
  }

  int carProfit() {
    int allProfit = 0;
    List<int> all = [0];

    for (var elem in state.goodsList) {
      final PriceModel model = getPriceModel(elem.goodsName);

      if (model.piecesPercentValueCar != null) {
        int moneyPosition = elem.price.toInt() * elem.count;
        all.add(moneyPosition * model.piecesPercentValueCar! ~/ 100);
      }
      if (model.piecesMoneyValueCar != null) {
        int moneyPosition = model.piecesMoneyValueCar! * elem.count;
        all.add(moneyPosition);
      }
      if (model.existenceMoneyValueCar != null) {
        int moneyPosition = model.existenceMoneyValueCar!;
        all.add(moneyPosition);
      } else {
        all.add(0);
      }
    }
    allProfit = all.reduce((value, element) => value + element).toInt();
    return allProfit;
  }

  void writeOrder(
    String address,
    bool takeMoney,
    int? id,
  ) async {
    Map map = {};
    List<CreateOrderGoodsEntity> goodsList = getFinalPrice();
    for (var element in goodsList) {
      map.addAll({element.goodsName: element.count});
    }
    int? manID;
    String notesFinish = state.addressEntity.notes.text;
    if (id == null) {
      manID = managerID;
    } else {
      manID = id;
      //записать номер телефона в базу клиентов
      RepoAdminGetPost().savePhoneNameAddress(
        state.addressEntity.phone.text,
        state.addressEntity.name.text,
        address,
      );
      notesFinish =
          'Заказ переопределен ! От менеджера ${managerID.toString()} менеджеру -> $id !!!    ${state.addressEntity.notes.text}';
    }
    String phoneManager = Hive.box(VarHive.nameBox).get(VarHive.phoneManager);
    final model = OrderModel(
      created: DateTime.now().millisecondsSinceEpoch,
      delivered: null,
      summa: state.allMoney,
      managerID: manID,
      managerProfit: managerProfit(),
      carID: null,
      carProfit: carProfit(),
      goodsList: map,
      address: address,
      phoneClient: state.addressEntity.phone.text,
      isDone: false,
      takeMoney: takeMoney,
      payMoneyManager: false,
      payMoneyCar: false,
      notes: notesFinish,
      name: state.addressEntity.name.text,
      time: state.addressEntity.time.text,
      phoneManager: phoneManager,
    );
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc()
        .set(model.toFirebase());
    initState();
  }

  void setUpdateGoodsList(Map data) {
    List<CreateOrderGoodsEntity> list = data.entries
        .map(
          (e) => CreateOrderGoodsEntity(
            goodsName: e.key,
            count: e.value,
            price: 0,
          ),
        )
        .toList();
    for (var elementList in list) {
      int indexCategoriesList = 0;
      for (var element in state.priceEntity.categoriesList) {
        int indexPriceModelList = 0;
        for (var elem in element.priceModelList) {
          if (elem.goodsName == elementList.goodsName) {
            state.priceEntity.categoriesList[indexCategoriesList]
                .countList[indexPriceModelList] = elementList.count;
          }
          indexPriceModelList++;
        }
        indexCategoriesList++;
      }
    }
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

  void updateFinalPrice() {
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

  void updateOrder(
    OrderModel nevModel,
    int money,
    String phoneClient,
    bool takeMoney,
    String notes,
    int manID,
    int managerProfit,
    int carProfit,
    Map? goodsMap,
    String time,
    String phoneManager,
  ) {
    Map map = {};
    List<CreateOrderGoodsEntity> goodsList = getFinalPrice();
    for (var element in goodsList) {
      map.addAll({element.goodsName: element.count});
    }
    final model = OrderModel(
      created: nevModel.created,
      delivered: null,
      summa: money,
      managerID: manID,
      managerProfit: managerProfit,
      carID: nevModel.carID,
      carProfit: carProfit,
      goodsList: goodsMap ?? map,
      address: nevModel.address,
      phoneClient: phoneClient,
      isDone: false,
      takeMoney: takeMoney,
      payMoneyManager: false,
      payMoneyCar: false,
      notes: notes,
      time: time,
      phoneManager: phoneManager,
    );
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc()
        .set(model.toFirebase());
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc(nevModel.docID)
        .delete();
    initState();
  }
}
