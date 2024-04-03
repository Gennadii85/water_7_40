import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/core/var_manager.dart';
import '../../../core/var_core.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/price_model.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';
import '../../../data/repositories/manager_page_repo.dart';

part 'order_count_state.dart';

class OrderCountCubit extends Cubit<OrderCountState> {
  List<PriceModel> prise;
  final int managerID = Hive.box(VarHive.nameBox).get(VarHive.managersID);
  OrderCountCubit(this.prise)
      : super(
          OrderCountInitState(
            listCount: listCount(prise),
            allMoney: 0,
            managerMoney: 0,
            prise: prise,
            percentManager:
                Hive.box(VarHive.nameBox).get(VarHive.managersPercent),
          ),
        );

  static List<int> listCount(List<PriceModel> prise) =>
      List<int>.generate(prise.length, (index) => 0);

  void getListCount(Map<dynamic, dynamic> goodsMap) {
    List<int> list = state.listCount;
    int countIndex = 0;
    for (var elem in prise) {
      if (goodsMap.containsKey(elem.goodsName)) {
        final entre =
            goodsMap.entries.where((element) => element.key == elem.goodsName);
        int val = entre.first.value;
        list.setAll(countIndex, [val]);
      }
      countIndex++;
    }
    emit(
      OrderCountState(
        listCount: list,
        allMoney: summaOrder(),
        managerMoney: managerProfit(),
        prise: state.prise,
        percentManager: state.percentManager,
      ),
    );
  }

  void initState() {
    emit(
      OrderCountInitState(
        listCount: List<int>.generate(prise.length, (index) => 0),
        allMoney: 0,
        managerMoney: 0,
        prise: prise,
        percentManager: state.percentManager,
      ),
    );
  }

  void addCount(int index) {
    int elem = state.listCount.elementAt(index);
    state.listCount.setAll(index, [elem + 1]);
    emit(
      OrderCountState(
        listCount: state.listCount,
        allMoney: summaOrder(),
        managerMoney: managerProfit(),
        prise: state.prise,
        percentManager: state.percentManager,
      ),
    );
  }

  void delCount(int index) {
    int elem = state.listCount.elementAt(index);
    if (elem == 0) {
      return;
    } else {
      state.listCount.setAll(index, [elem - 1]);
      emit(
        OrderCountState(
          listCount: state.listCount,
          allMoney: summaOrder(),
          managerMoney: managerProfit(),
          prise: state.prise,
          percentManager: state.percentManager,
        ),
      );
    }
  }

  int summaOrder() {
    int allMoney = 0;
    List<int> all = [];
    int countIndex = 0;
    for (var elem in prise) {
      all.add(elem.goodsPrice.toInt() * state.listCount[countIndex]);
      countIndex++;
    }
    allMoney = all.reduce((value, element) => value + element);
    return allMoney;
  }

  int managerProfit() {
    int allProfit = 0;
    List<int> all = [0];
    int countIndex = 0;

    for (var elem in prise) {
      if (state.listCount[countIndex] != 0) {
        if (elem.piecesPercentValueManager != null) {
          int moneyPosition =
              elem.goodsPrice.toInt() * state.listCount[countIndex];
          all.add(moneyPosition * elem.piecesPercentValueManager! ~/ 100);
        }
        if (elem.piecesMoneyValueManager != null) {
          int moneyPosition =
              elem.piecesMoneyValueManager! * state.listCount[countIndex];
          all.add(moneyPosition);
        }
        if (elem.existenceMoneyValueManager != null) {
          int moneyPosition = elem.existenceMoneyValueManager!;
          all.add(moneyPosition);
        }
        if (elem.managerPercent) {
          if (state.percentManager == null) {
            all.add(0);
          } else {
            int moneyPosition =
                elem.goodsPrice.toInt() * state.listCount[countIndex];
            all.add(moneyPosition * state.percentManager! ~/ 100);
          }
        } else {
          all.add(0);
        }
      }

      countIndex++;
    }
    allProfit = all.reduce((value, element) => value + element).toInt();
    return allProfit;
  }

  int carProfit() {
    int allProfit = 0;
    List<int> all = [];
    int countIndex = 0;

    for (var elem in prise) {
      if (state.listCount[countIndex] != 0) {
        if (elem.piecesPercentValueCar != null) {
          int moneyPosition =
              elem.goodsPrice.toInt() * state.listCount[countIndex];
          all.add(moneyPosition * elem.piecesPercentValueCar! ~/ 100);
        }
        if (elem.piecesMoneyValueCar != null) {
          int moneyPosition =
              elem.piecesMoneyValueCar! * state.listCount[countIndex];
          all.add(moneyPosition);
        }
        if (elem.existenceMoneyValueCar != null) {
          int moneyPosition = elem.existenceMoneyValueCar!;
          all.add(moneyPosition);
        } else {
          all.add(0);
        }
      }

      countIndex++;
    }
    allProfit = all.reduce((value, element) => value + element).toInt();
    return allProfit;
  }

  void writeOrder(
    String address,
    String phoneClient,
    bool takeMoney,
    String? notes,
  ) async {
    int? id = await RepoManagerPage().checkAddress(address);
    Map map = {};
    int countIndex = 0;
    for (var elem in state.listCount) {
      if (elem > 0) {
        map.addAll({prise[countIndex].goodsName: state.listCount[countIndex]});
      }
      countIndex++;
    }
    int? manID;
    if (id == null) {
      manID = managerID;
    } else {
      manID = id;
      RepoAdminGetPost().savePhoneAddress(phoneClient, address);
      //записать номер телефона в базу клиентов
    }

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
      phoneClient: phoneClient,
      isDone: false,
      takeMoney: takeMoney,
      payMoneyManager: false,
      payMoneyCar: false,
      notes: notes,
    );
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc()
        .set(model.toFirebase());

    initState();
  }

  void updateOrder(
    String docID,
    String address,
    String phoneClient,
    bool takeMoney,
    String notes,
    int manID,
    int managerProfit,
    int carProfit,
  ) {
    Map map = {};
    int countIndex = 0;
    for (var elem in state.listCount) {
      if (elem > 0) {
        map.addAll({prise[countIndex].goodsName: state.listCount[countIndex]});
      }
      countIndex++;
    }
    final model = OrderModel(
      created: DateTime.now().millisecondsSinceEpoch,
      delivered: null,
      summa: state.allMoney,
      managerID: manID,
      managerProfit: managerProfit,
      carID: null,
      carProfit: carProfit,
      goodsList: map,
      address: address,
      phoneClient: phoneClient,
      isDone: false,
      takeMoney: takeMoney,
      payMoneyManager: false,
      payMoneyCar: false,
      notes: notes,
    );
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc()
        .set(model.toFirebase());
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc(docID)
        .delete();

    initState();
  }
}
